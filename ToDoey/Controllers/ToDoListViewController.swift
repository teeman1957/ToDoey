//
//  ToDoListViewController.swift
//  ToDoey
//
//  Created by Anthony Shaw on 4/16/18.
//  Copyright © 2018 Anthony Shaw. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    // var itemArray = ["Item1", "Item2", "Item3"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    
    }

    // Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // setup constant to use instead of repeating itemArray[indexPath.row] in the subsequent statements
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // use ternary operator to cut down the below code
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
//        return cell
// is replaced with below ternary operator line if cell.accessoryType = item.done is true then set to 1st value else 2nd value
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    // Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        /* below is the long method for setting the done Boolean
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        }
         
         the next method is shorter and cleaner
        */
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        
        
        /* if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        */
        // stop it from staying grey, instead flashes grey then retruns to white
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks the Add Item button
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
          
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error writing file \(error)")
        }
        
        self.tableView.reloadData()
    }

    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error loading data \(error)")
            }
        }
        
        do {
            
        }
    }
}
























