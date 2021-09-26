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
        
        let categoryItem0 = Category(context: context)
        categoryItem0.name = "Food"
        
        let categoryItem1 = Category(context: context)
        categoryItem1.name = "Clothing"
        
        let categoryItem2 = Category(context: context)
        categoryItem2.name = "Gaming"
        
        categoryArray = [categoryItem0, categoryItem1, categoryItem2]
        
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

    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
}
