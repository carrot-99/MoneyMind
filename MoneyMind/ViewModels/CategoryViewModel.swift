//  CategoryViewModel.swift

import Foundation
import RealmSwift

class CategoryViewModel: ObservableObject {
    private var realm: Realm
    @Published var categories: [Category] = []
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    init() {
        realm = try! Realm()
        loadCategories()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self).toArray()
    }
    
    func addCategory(name: String) {
        guard !name.isEmpty else { return }
        let newCategory = Category()
        newCategory.name = name
        
        try! realm.write {
            realm.add(newCategory)
        }
        loadCategories()
    }
    
    func deleteCategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let category = categories[index]
        
        try! realm.write {
            realm.delete(category)
        }
        loadCategories()
    }
    
    func updateCategory(category: Category, newName: String) {
        guard !newName.isEmpty, let existingCategory = realm.object(ofType: Category.self, forPrimaryKey: category.id) else { return }
        try! realm.write {
            existingCategory.name = newName
        }
        loadCategories()
    }
    
    func isCategoryInUse(categoryName: String) -> Bool {
        let items = realm.objects(SavingsItem.self).filter("category == %@", categoryName)
        return !items.isEmpty
    }
    
    func safeDeleteCategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let category = categories[index]
        
        if category.name == "未分類" {
            // "未分類"カテゴリは削除不可
            alertMessage = "\"未分類\"カテゴリは削除できません。"
            showAlert = true
            return
        }

        if isCategoryInUse(categoryName: category.name) {
            alertMessage = "\(category.name) は使用中のため削除できません。"
            showAlert = true
        } else {
            do {
                try realm.write {
                    if let categoryToDelete = realm.object(ofType: Category.self, forPrimaryKey: category.id) {
                        realm.delete(categoryToDelete)
                        print("Success Deleting Category")
                    }
                }
                DispatchQueue.main.async {
                    self.loadCategories()
                }
            } catch let error as NSError {
                print("Error deleting category: \(error.localizedDescription)")
                alertMessage = "削除中にエラーが発生しました: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

}
