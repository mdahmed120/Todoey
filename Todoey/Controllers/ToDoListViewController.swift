//
//  ViewController.swift
//  Todoey
//
//  Created by Macbook Air on 9/9/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    /**
     this var is set from CategoryVC, its optional and it contains didSet{} Method
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return todoItems?.count ?? 1
    }
    
    //its only called when the view starts
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //create a cell and set the text
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            
            //we can shorten the below if statement with ternary operator
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Item Added"
        }
        
        
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
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
        
        //updating the item in realm db
        if let item = todoItems?[indexPath.row]
        {
            do
            {
                try realm.write {
                    //false becomes true N true becomes false
                    item.done = !item.done
                    
                    //to delete item
                    //realm.delete(item)
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
            
            if let currentCategory = self.selectedCategory
            {
                do
                {
                    try self.realm.write{
                        let item = Item()
                        item.title = textfield.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
    
                }catch{
                    print("Error saving context \(error)")
                }
            }
            self.tableView.reloadData()


            
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
     Loading items from Realm DB
     */
    func loadItems()
    {
       
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    /*
     Search bar delegate method
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //quering realm db
        //check Nspredicate cheatsheet in realmdb website
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
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

