//
//  ViewController.swift
//  Todoey
//
//  Created by Tomasz Bochenek on 10/10/2019.
//  Copyright © 2019 Tomasz Bochenek. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    @IBOutlet var todoTableView: UITableView!
    var todoItems: Results<Item>?{
        didSet{
            self.tableView.reloadData()
        }
    }
    var selectedCategory: CategoryOfItem?{
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask))
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        
        let backgroundColor = UIColor(hexString: selectedCategory!.color)
        let textColor = UIColor.init(contrastingBlackOrWhiteColorOn: backgroundColor, isFlat: true)
        navigationController!.navigationBar.backgroundColor = backgroundColor
        navigationController!.navigationBar.tintColor = textColor
        
        let textAttributes = [NSAttributedString.Key.foregroundColor : textColor]
        navigationController!.navigationBar.largeTitleTextAttributes = textAttributes
    }

    func loadItems(searchText: String = "" ){
        if(searchText != ""){
            todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
            .filter("title CONTAINS[cd] %@", searchText)
        }else{
            todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        }
    }
    
    //MARK: Tableview Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let itemToShow = todoItems?[indexPath.row]{
        
            cell.textLabel!.text = itemToShow.title
            if let count = todoItems?.count{
                let backgroundColor = UIColor(hexString: selectedCategory!.color).darken(
                    byPercentage: CGFloat(indexPath.row) / CGFloat(count)
                )
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: backgroundColor, isFlat: false)
            }
            
            cell.accessoryType = itemToShow.done ? .checkmark : .none
        }else {
            cell.textLabel!.text = "no items added yet"
        }
        
        return cell
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "create item", message: "", preferredStyle: .alert)
    
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            try! self.realm.write {
                let newItem = Item()
                newItem.title = alert.textFields![0].text!
                newItem.done = false
                self.selectedCategory?.items.append(newItem)
                self.realm.add(newItem)
                self.loadItems()
            }
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "create new item"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch{
                print("error saving done")
            }
        }

        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch{
                print("error deleting")
            }
        }
    }
}

//MARK: - search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadItems(searchText: searchBar.text!)
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
