
import Foundation
import RealmSwift

class Item : Object { //subclassing Realm Object
    @objc dynamic var title : String = "" // specifying categories our Items must have
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date? 
    var parentCategory = LinkingObjects (fromType: Category.self, property: "items") // inverse realtionship with Category class, property: "items" talks to let items = List<Item>() in Category
}
