//
//  ViewController.swift
//  Dodo
//
//  Created by Tyrone Oggen on 2021/09/11.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //    var itemArray = ["Have coffee", "Have cereal", "Watch Udemy Course", "a", "b", "c", "d", "a", "b", "c", "d", "a", "b", "c", "d", "a", "b", "c", "d", "a", "b", "c", "d", "a", "b", "c", "d", "a", "b", "c", "d"]
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem0 = Item()
        newItem0.title = "Have coffee"
        itemArray.append(newItem0)
        
        let newItem1 = Item()
        newItem1.title = "Have cereal"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Watch Udemy Course"
        itemArray.append(newItem2)
        
        //        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
        //            itemArray = items
        //        }
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.done.toggle()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    @IBAction func addTodoListItemButtonPressed(_ sender: Any) {
        //Created to allow the alertAction to access the value at .addTextField after the action is executed
        var textField = UITextField()
        
        //Alert configuration
        let alert = UIAlertController(title: "Add new Dodo item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

