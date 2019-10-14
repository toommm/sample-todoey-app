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
    var itemArray = [Item]()
    var dataFilePath: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
//            itemArray = items
//        }
        
        dataFilePath = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("Items.plist")
        
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Buy eggos"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "blah blah"
        itemArray.append(newItem3)
        
        loadItems()
        
    }

    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                
            }
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
        let itemToShow = itemArray[indexPath.row]
        
        todoTableViewCell.label.text = itemToShow.title
        todoTableViewCell.accessoryType = itemToShow.done ? .checkmark : .none
        
        return todoTableViewCell
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "create item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
//            itemArray.append()
            let newItem = Item()
            newItem.title = alert.textFields![0].text!
            self.itemArray.append(newItem)
            self.saveItems()
           
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "create new item"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
                   do{
                       let data = try encoder.encode(itemArray)
                       try data.write(to: dataFilePath!)
                   } catch {
                       
                   }
                   
                   self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

