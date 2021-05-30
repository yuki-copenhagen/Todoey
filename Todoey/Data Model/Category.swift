
import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = "" //specifying properties our Category class must have 
    let items = List<Item>() //similar to arrays
}
