//
//  ViewController.swift
//  Todoey
//
//  Created by Tomasz Bochenek on 10/10/2019.
//  Copyright © 2019 Tomasz Bochenek. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    @IBOutlet var todoTableView: UITableView!
    var itemArray = [Item]()
    var selectedCategory: CategoryOfItem?{
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask))
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do{
            
            let newPredicate = NSPredicate(format: "parentCategory.name matches %@", selectedCategory!.name!)
            if let oldPredicate = request.predicate {
                let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [oldPredicate, newPredicate])
                request.predicate = compound
            } else{
                request.predicate = newPredicate
            }
            
            itemArray = try context.fetch(request)
        }catch{
            print("error fetching items: \(error)")
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
                        
            let newItem = Item(context: self.context)
            newItem.title = alert.textFields![0].text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
                do{
                    try self.context.save()
                } catch {
                   print("error saving context \(error)")
                }
                   
                self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: - search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sort = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sort]
        loadItems(with: request)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count == 0){
            loadItems()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
