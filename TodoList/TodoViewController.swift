//
//  TodoViewController.swift
//  TodoList
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let databaseContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemsModel = [ItemModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadItems()
        print(itemsModel)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        let currItem = itemsModel[indexPath.row]
        cell.textLabel?.text = currItem.itemName
        cell.accessoryType = currItem.checkedFlag ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView Delegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsModel[indexPath.row].checkedFlag = !itemsModel[indexPath.row].checkedFlag
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        var textEntered = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = ItemModel(context: self.databaseContext)
            item.itemName = textEntered.text
            item.checkedFlag = false
            self.itemsModel.append(item)
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textEntered = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try databaseContext.save()
        } catch {
            print("Error is found \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<ItemModel> = ItemModel.fetchRequest()) {
        do {
            itemsModel = try databaseContext.fetch(request)
        } catch {
            print("Error \(error)")
        }
        tableView.reloadData()
    }
}

extension TodoViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<ItemModel> = ItemModel.fetchRequest()
        request.predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        loadItems(with: request)
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
