//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Tomasz Bochenek on 16/10/2019.
//  Copyright © 2019 Tomasz Bochenek. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories: Results<CategoryOfItem>?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    func loadItems(){
        categories = realm.objects(CategoryOfItem.self)
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "add category", message: "type in your message", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ADD", style: .default, handler: { (action) in
            alert.dismiss(animated: true) {
                let newCategory = CategoryOfItem()
                newCategory.name = (alert.textFields?.first!.text)!
              
                do{
                    try self.realm.write {
                        self.realm.add(newCategory)
                    }
                    self.loadItems()
                    self.tableView.reloadData()
                }catch{
                    print("error saving category \(error)")
                }
            }
        }))
        alert.addTextField { (textField) in
            textField.placeholder = "type your category here"
        }
        present(alert, animated: true)
    }
    
    //MARK: table view data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "CategoryOfItemTableViewCell") as! CategoryOfItemTableViewCell)
        cell.label.text = categories?[indexPath.row].name ?? "no categotries added yet"
        return cell
    }
    
    //MARK: table veiw delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            viewController.selectedCategory = categories?[indexPath.row]
        }
    }
}
