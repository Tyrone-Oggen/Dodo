//
//  ViewController.swift
//  Dodo
//
//  Created by Tyrone Oggen on 2021/09/11.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //Set to an optional Category because it will be nil when the class is loaded
    var selectedCategory : Category? {
        //Everything bewtween the follwing curly braces will be run, only when selectedCategory has a value which is why we run loadItems because it is dependant on the selectedCategory property
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        
        item.done.toggle()
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    @IBAction func addTodoListItemButtonPressed(_ sender: Any) {
        //Created to allow the alertAction to access the value at .addTextField after the action is executed
        var textField = UITextField()
        
        //Alert configuration
        let alert = UIAlertController(title: "Add new Dodo item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            //We set the relationShip category we created inside the DataModel so that it will get all relevant data accordingly
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving data to context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    /*
        default value provided for load() method if no parameter is desired to be passed
        predicate added to cater for need for compound predicate in order to only get the selectedCategory, as well as any further predicates passed through as an argument (for example) the search bar
        predicate argument set to nil so that the loadItems() that don't need one and just want to load all the values can run without needing to pass the value
     */
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //To cater for if there isn't a predicate passed through the argument
        if let predicatePassedThroughArgument = predicate {
            //This allows us to create a predicate for the request that will ensure that both the category selected and any further predicates that are passed through the arguments using Subpredicates
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicatePassedThroughArgument])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error loading data to from context: \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Searchbar delegate methods
extension TodoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
