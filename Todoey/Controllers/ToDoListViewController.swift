//
//  ViewController.swift
//  Todoey
//
//  Created by Macbook Air on 9/9/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    /**
     this var is set from CategoryVC, its optional and it containd didSet{} Method
     which mean as soon as it has been set from CategoryVC, anything inside didSet{}
     will be called,
     and in that we are calling loadItems
     */
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //singleton, getting context ref from AppDelegate Class
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    //its only called when the view starts
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //create a cell and set the text
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //we can shorten the below if statement with ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        //displaying the checkmark
//        if item.done == true
//        {
//            cell.accessoryType = .checkmark
//        }
//        else
//        {
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "" , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        { (action) in
            //what will happen once the user clicks the Add Item Button on our UIAlert
           // print(textfield.text)
            
            
            let newitem = Item(context: self.context)
            newitem.title  = textfield.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            self.itemArray.append(newitem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manupulation Methods
    
    /*
     Saving data in CoreData DB.
    */
    func saveItems()
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
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }else
        {
            request.predicate = categoryPredicate
        }
    
        
        do
        {
            itemArray = try context.fetch(request)
        }catch
        {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    /*
     Search bar delegate method
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptr]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            loadItems()
            //making keyboard goaway
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

