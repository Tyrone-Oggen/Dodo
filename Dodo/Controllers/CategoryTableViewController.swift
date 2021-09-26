//
//  CategoryTableViewController.swift
//  Dodo
//
//  Created by Tyrone Oggen on 2021/09/26.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
        
    //MARK: - Tableview Delegate methods
    
    //MARK: - Data manipulation methods
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving data to context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //default value provided for load() method if no parameter is desired to be passed
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error data data to from: \(error)")
        }
        
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
}
