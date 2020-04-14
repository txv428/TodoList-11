//
//  ToDoTableViewController.swift
//  TodoList
//
//  Created by Apple on 10/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
//    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
//    let defaults = UserDefaults.standard

    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemsModel = [TodoListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
//        if let items = defaults.array(forKey: "TodoListModel") as? [TodoListModel] {
//            itemsModel = items
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        let currItem = itemsModel[indexPath.row]
        cell.textLabel?.text = currItem.itemName
        cell.accessoryType = currItem.checkedFlag ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView Delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsModel[indexPath.row].checkedFlag = !itemsModel[indexPath.row].checkedFlag
        saveItems()
//        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        var textEntered = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemsModel.append(TodoListModel(itemName: textEntered.text!, checkedFlag: false))
            self.saveItems()
//            self.defaults.set(self.itemsModel, forKey: "TodoListModel")
//            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textEntered = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemsModel)
            try data.write(to: filePath!)
        } catch {
            print("Error is found \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        do {
            let data = try Data(contentsOf: filePath!)
            let decoder = PropertyListDecoder()
            do {
                itemsModel = try decoder.decode([TodoListModel].self, from: data)
            }
            catch {
                print("error decoding \(error)")
            }
        } catch {
            print("error here is \(error)")
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
