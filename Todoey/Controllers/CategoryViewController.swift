
import UIKit
import RealmSwift
//import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm() //database
    
    var categoryArray: Results<Category>?
    
 //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.rowHeight = 65.0
    }
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
  /*  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    } */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
    //    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
       // reusable cell
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
    //    cell.delegate = self
        
        return cell
    }
    
    
    //MARK: - TableView Dlegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

    //MARK: - Data Manipulation Methods

    func save(category: Category) {
        
do {
    try realm.write {
        realm.add(category)
    }
} catch {
print ("Error saving category \(error)")
}
        
    self.tableView.reloadData()
}

func loadCategory () {
    
    categoryArray = realm.objects(Category.self)
  
 /*   let request : NSFetchRequest<Category> = Category.fetchRequest()

do {
categoryArray = try context.fetch(request)
} catch {
    print ("Error loading categories \(error)")
} */
    tableView.reloadData()
}

    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath){
        
            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)}
                } catch {
                    print("Error deleting category, \(error)")
                }
                   // tableView.reloadData()
              }
        
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController (title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
        //    self.categoryArray.append(newCategory)
            self.save(category: newCategory)
           // self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//moved to Swipe Table View Controller

//MARK: - Extension Swipr Table View Delegate Methods

/*extension CategoryViewController: SwipeTableViewCellDelegate {

 func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
     guard orientation == .right else { return nil }

     let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
         
         print ("Delete cell")
         
         // handle action by updating model with deletion
        
 /*        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
     
         do {
             try self.realm.write {
                 self.realm.delete(categoryForDeletion)}
         } catch {
             print("Error deleting category, \(error)")
         }
            // tableView.reloadData()
       }
     } */

     // customize the action appearance
     deleteAction.image = UIImage(named: "Trash Icon")

     return [deleteAction]
 }
 
 func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
     var options = SwipeOptions()
     options.expansionStyle = .destructive
     return options
 }
 }
 */
