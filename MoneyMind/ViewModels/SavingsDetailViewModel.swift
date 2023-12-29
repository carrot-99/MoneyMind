//  SavingsDetailViewModel.swift

import Foundation
import RealmSwift

class SavingsDetailViewModel: ObservableObject {
    private var realm: Realm
    private var item: SavingsItem
    
    @Published var name: String = ""
    @Published var amount: Double = 0
    @Published var memo: String = ""
    @Published var category: String = ""
    @Published var categories: [String] = []
    @Published var date: Date = Date()
    
    init(item: SavingsItem) {
        realm = try! Realm()
        
        self.item = item
        name = item.name
        amount = item.amount
        memo = item.memo ?? ""
        category = item.category
        date = item.date
        
        loadCategories()
    }
    
    func loadCategories() {
        var loadedCategories = Array(realm.objects(Category.self))

        // "未分類"カテゴリを確認し、存在しない場合は追加
        if !loadedCategories.contains(where: { $0.name == "未分類" }) {
            let uncategorized = Category()
            uncategorized.name = "未分類"
            try! realm.write {
                realm.add(uncategorized)
            }
            loadedCategories.insert(uncategorized, at: 0)
        } else {
            if let uncategorizedIndex = loadedCategories.firstIndex(where: { $0.name == "未分類" }) {
                let uncategorized = loadedCategories.remove(at: uncategorizedIndex)
                loadedCategories.insert(uncategorized, at: 0)
            }
        }

        categories = loadedCategories.map { $0.name }
    }
    
    func saveChanges() {
        try! realm.write {
            item.name = name
            item.amount = amount
            item.memo = memo
            item.category = category
            item.date = date
        }
    }
    
    func deleteItem() {
        try! realm.write {
            realm.delete(item)
        }
    }
}
