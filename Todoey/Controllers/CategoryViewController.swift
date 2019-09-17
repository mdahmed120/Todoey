//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Macbook Air on 9/16/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController
{
    var categoryArray = [Category]()
    
    //singleton, getting context ref from AppDelegate Class
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()


        
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a cell and set the text
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let cat = categoryArray[indexPath.row]
        cell.textLabel?.text = cat.name
        
        return cell

    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(categoryArray[indexPath.row].name)
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    /*
     Saving data in CoreData DB.
     */
    func saveCategories()
    {
        do
        {
            try self.context.save()
            
        }catch
        {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    /*
     Loading items from CoreData DB
     */
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do
        {
            categoryArray = try context.fetch(request)
        }catch
        {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    //MARK: - AddButtonPressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "" , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default)
        { (action) in
            //what will happen once the user clicks the Add Item Button on our UIAlert
            let cat = Category(context: self.context)
            cat.name  = textfield.text!
            
            self.categoryArray.append(cat)
            
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Category"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }


}
