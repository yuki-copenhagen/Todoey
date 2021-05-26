

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
 //   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // let defaults = UserDefaults.standard // singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
     /*   let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demorgorgon"
        itemArray.append(newItem3) */
        
       // let request : NSFetchRequest<Item> = Item.fetchRequest()

      /*  if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        itemArray = items
        }    // to retrieve saved data */
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done /* == true*/ ? .checkmark: .none
        
        /*  if item.done == true {
         cell.accessoryType = .checkmark
         } else {
         cell.accessoryType = .none
         } */
        
        return cell
    }
    
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //context.delete(itemArray[indexPath.row]) //delete temporarily w/o saving
      //itemArray.remove(at: indexPath.row) //delete data from DB
        
        
      //  itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        /*  if itemArray[indexPath.row].done == false {
         itemArray[indexPath.row].done = true
         } else {
         itemArray[indexPath.row].done = false
         } */
        
        /*    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
         tableView.cellForRow(at: indexPath)?.accessoryType = .none
         } else {
         tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
         } */
        
      //  tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - AddNewItemButton
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController (title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the add button on our UIAlert
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
         //   self.defaults.set(self.itemArray, forKey: "TodoListArray") //local storage to keep data
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    
    //MARK: - Model Manipulation Methods
    
func saveItems() {

//let encoder = PropertyListEncoder()

do {
    try context.save()
  //  let data =  try encoder.encode(itemArray) // Item has toconformto encodable protocol in Model
  //  try data.write(to: dataFilePath!)
} catch {
    print ("Error saving context, \(error)")
}

   tableView.reloadData()
}
    
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate 
        }
        
    //    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        
   //     request.predicate = compoundPredicate
    
  //  let request : NSFetchRequest<Item> = Item.fetchRequest()
    
    do {
   itemArray = try context.fetch(request)
    } catch {
        print ("Error fetching data from context \(error)")
    }
    }
    
     /* if let data = try? Data(contentsOf: dataFilePath!) {
          let decoder = PropertyListDecoder ()
        
        do {
          itemArray = try decoder.decode([Item].self, from: data) //Item has to conform to decodable protocol in Model
        } catch {
            print("Error decoding item array, \(error)")
        }
        }
    } */

}

//MARK: - Search Bar

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async { //DispatchQueue decides what is being processed first / last in the background
                searchBar.resignFirstResponder()
            }
            
            
        }
        
    }
        
     //   request.sortDescriptors = [sortDescriptor]
        
       /* do {
       itemArray = try context.fetch(request)
        } catch {
            print ("Error fetching data from context \(error)")
        } */
        
      //  tableView.reloadData()
   
}
