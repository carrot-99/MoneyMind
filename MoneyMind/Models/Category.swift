//  Category.swift

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var id = UUID().uuidString // ユニークID
    @objc dynamic var name: String = ""      // カテゴリ名
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var items: [SavingsItem] {
        return realm?.objects(SavingsItem.self).filter("category == %@", name).toArray() ?? []
    }
}

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}
