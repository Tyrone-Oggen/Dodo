//
//  CategoryTableViewController.swift
//  Dodo
//
//  Created by Tyrone Oggen on 2021/09/26.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    //We don't need to worry about the try! is because we already catered for the caution of the first realm being created inside the AppDelegate so we can safely unwrap the try!
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        
        return cell
    }
        
    //MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Downcasted since we know where the segue is navigating to
        let destinationVC = segue.destination as! TodoListTableViewController
        
        /*
            This returns an optional indexPath so we wrap it in an if let, even though it's going to be triggered once a row is actually selected
            Swift will know the indexPath because this method is called inside the didSelectRowAt metho which will have access to this method
         */
        if let indexPath = tableView.indexPathForSelectedRow {
            //We set the property selectedCategory on the destinationVC (which is the TodoListVC) as the Category object row that gets selected
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Add Categories method
    @IBAction func addButtonPressed(_ sender: UIButton) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new todo list Categoey", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            
            newCategory.name = textfield.text!
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textfield = alertTextField
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data manipulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data to context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
}
