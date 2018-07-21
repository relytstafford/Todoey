//
//  ViewController.swift
//  Todoey
//
//  Created by Ty Stafford on 6/29/18.
//  Copyright © 2018 Tyler Stafford. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        )

        loadItems()
        
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Ternary operator
        // value = condition? ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        line 53 replaces 54 - 60
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //        print(itemArray[indexPath.row])
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        this line 63 replaces all of 65 - 70
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else {
//            itemArray[indexPath.row].done = false
//        }
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks add item button on UIAlert
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            newItem.parentCategory = self.selectedCategory
            
           self.saveItems()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveItems() {

        do {
         try context.save()
        }
        catch {
            print("Error saving conetext \(error)")
        }
        self.tableView.reloadData()
    
    
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionialPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionialPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }

        
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

    
    
    
}
//MARK: - SearchBarMethods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
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






