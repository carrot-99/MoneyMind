//  DatabaseManager.swift

import Foundation
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    private var realm: Realm
    
    private init() {
        realm = try! Realm()
    }
    
    func setupDefaultCategories() {
        let existingCategories = realm.objects(Category.self)
        if existingCategories.isEmpty {
            try! realm.write {
                for categoryName in Constants.defaultCategories {
                    let newCategory = Category()
                    newCategory.name = categoryName
                    realm.add(newCategory)
                }
            }
        }
    }
    
    func addOrUpdate<T: Object>(_ object: T) {
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func objects<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func object<T: Object, KeyType>(ofType type: T.Type, forPrimaryKey key: KeyType) -> T? {
        return realm.object(ofType: type, forPrimaryKey: key)
    }
}
