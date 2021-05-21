

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // let defaults = UserDefaults.standard // singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
     /*   let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demorgorgon"
        itemArray.append(newItem3) */
        
        loadItems()
        
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
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
            
            //     print(textField.text)
            let newItem = Item()
            newItem.title = textField.text!
            
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
    
let encoder = PropertyListEncoder()

do {
    let data =  try encoder.encode(itemArray)
    try data.write(to: dataFilePath!)
} catch {
    print ("Error encoding item array, \(error)")

}

   tableView.reloadData()
}
    
    func loadItems() {
      if let data = try? Data(contentsOf: dataFilePath!) {
          let decoder = PropertyListDecoder ()
        
        do {
          itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding item array, \(error)")
        }
        }
    }

}
