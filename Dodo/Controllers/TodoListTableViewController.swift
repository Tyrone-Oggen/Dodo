//
//  ViewController.swift
//  Dodo
//
//  Created by Tyrone Oggen on 2021/09/11.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    //Set to an optional Category because it will be nil when the class is loaded
    var selectedCategory : Category? {
        //Everything bewtween the follwing curly braces will be run, only when selectedCategory has a value which is why we run loadItems because it is dependant on the selectedCategory property
        didSet {
            loadItems() 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items for category"
        }
        
        return cell
    }
    
    //MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = todoItems[indexPath.row]
//
//        item.done.toggle()
//
//        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    @IBAction func addTodoListItemButtonPressed(_ sender: Any) {
        //Created to allow the alertAction to access the value at .addTextField after the action is executed
        var textField = UITextField()
        
        //Alert configuration
        let alert = UIAlertController(title: "Add new Dodo item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { [self] (action) in
            
            if let currentCategory = selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("There was an error saving the data to Realm: \(error)")
                }
                
                tableView.reloadData()
            }
            
            
            
            tableView.reloadData()
//            //We set the relationShip category we created inside the DataModel so that it will get all relevant data accordingly
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemArray.append(newItem)
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
}

//MARK: - Searchbar delegate methods
//extension TodoListTableViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
