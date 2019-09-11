//
//  ViewController.swift
//  Todoey
//
//  Created by Macbook Air on 9/9/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadItems()
        
//        //saving the itemsArray in device
//        if let items = userDefaults.array(forKey: "TodoListArray") as? [Item]
//        {
//            itemArray = items
//        }
    }
    
    //MARK - Tableview Datasource Methods
    
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
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //    print(itemArray[indexPath.row])
        //marking the check mark true or false
//        if itemArray[indexPath.row].done == false
//        {
//            itemArray[indexPath.row].done = true
//        }
//        else
//        {
//            itemArray[indexPath.row].done = false
//        }
        
        //above if statement can be replaced with the single line of code, as it uses boolean which has only two states
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //refreshing the table view to show the checkmark when a cell is selected or deselected
        //tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "" , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        { (action) in
            //what will happen once the user clicks the Add Item Button on our UIAlert
            print(textfield.text)
            
            let newitem = Item()
            newitem.title  = textfield.text!
            
            self.itemArray.append(newitem)
            
            self.saveItems()
            
            
//            self.userDefaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manupulation Methods
    
    func saveItems()
    {
        //encoding the data for NSCoder
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch
        {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            let decoder = PropertyListDecoder()
            do
            {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
                print("Error encoding item array, \(error)")

            }
        }
        
    }
}

