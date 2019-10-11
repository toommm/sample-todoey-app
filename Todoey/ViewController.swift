//
//  ViewController.swift
//  Todoey
//
//  Created by Tomasz Bochenek on 10/10/2019.
//  Copyright © 2019 Tomasz Bochenek. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    @IBOutlet var todoTableView: UITableView!
    var itemArray = ["Find Mike", "Buy eggos", "destroy Demogorgon"]
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
    }

    //MARK: Tableview Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        let textToShow = itemArray[indexPath.row]
        
        todoTableViewCell.label.text = textToShow
        
        return todoTableViewCell
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "create item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
//            itemArray.append()
            self.itemArray.append(alert.textFields![0].text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "create new item"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

