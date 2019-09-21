//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Macbook Air on 9/16/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController
{
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //coalacing operator
        //if array is not nill then it will populate the data
        //if its nill then it will show just 1 row
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a cell and set the text
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        
        return cell

    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        print(categoryArray[indexPath.row].name)
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    /*
     Saving data in CoreData DB.
     */
    func saveCategories(category: Category)
    {
        do
        {
            try realm.write {
                realm.add(category)
            }
            
        }catch
        {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    /*
     Loading items from CoreData DB
     */
    func loadCategories()
    {
        categoryArray = (realm.objects(Category.self))
        
        tableView.reloadData()
    }
    
    
    //MARK: - AddButtonPressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "" , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default)
        { (action) in
            //what will happen once the user clicks the Add Item Button on our UIAlert
            let cat = Category()
            cat.name  = textfield.text!
            
            self.saveCategories(category: cat)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Category"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }


}
