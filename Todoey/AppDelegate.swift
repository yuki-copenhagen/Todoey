
import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
     //   print(Realm.Configuration.defaultConfiguration.fileURL)
       
       /* let data = Data()
        data.name = "Angela"
        data.age = 12 */
        
        
        do {
        /*let realm*/_ = try Realm()
         //  try realm.write {
         //       realm.add(data)
         // }
    } catch {
            print("Error initializing new realm application, \(error)")
        }
        
        
        return true
    }

    /*
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data Stack

  lazy var persistentContainer: NSPersistentContainer = { //NSPersistentContainer - database
       
        let container = NSPersistentContainer(name: "DataModel") // match DataModel
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving Support

    func saveContext () {
        let context = persistentContainer.viewContext //area where you can change /update your datat before moving it to the permanent storage
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
*/
}


