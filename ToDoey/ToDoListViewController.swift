//
//  ToDoListViewController.swift
//  ToDoey
//
//  Created by Anthony Shaw on 4/16/18.
//  Copyright © 2018 Anthony Shaw. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["Buy Mild", "Buy Eggs", "Buy Bread", "A long text string that I hope is too big for the display so we can see what happens"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    // Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    
    // Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // stop it from staying grey, instead flashes grey then retruns to white
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}

