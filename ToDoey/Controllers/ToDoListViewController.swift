//
//  ToDoListViewController.swift
//  ToDoey
//
//  Created by Anthony Shaw on 4/16/18.
//  Copyright © 2018 Anthony Shaw. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    var itemArray = [Item]()
    // var itemArray = ["Item1", "Item2", "Item3"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
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
        // reverses current boolean from true to false or false to true, instead of if statement
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // update other properties but what if you want to change the text of an entry?
        // itemArray[indexPath.row].title = "Completed"
        
        // delete the selected row, add a confirmation dialogue?
        // you must delete from context first, otherwise app will crash cause indexPath.row no longer
        // exists in array
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        self.saveItems()
        
        // keeps the selected tableview row from staying selected color, just flashes then back to normal
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks the Add Item button
            
            let newItem = Item(context: self.context)
            newItem.parentCategory = self.selectedCategory
            newItem.title = textField.text!
            newItem.done = false
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
        // this is a "commit" to the database
        do {
            
            try context.save() // commit occurs here
        } catch {
            print("error saving data \(error)")
        }
        
        self.tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        // print("request is \(request)")
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error on fetch /(error)")
        }
        
        self.tableView.reloadData()
    }
    
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // the [cd] indicates to ignore case and diacritics
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
