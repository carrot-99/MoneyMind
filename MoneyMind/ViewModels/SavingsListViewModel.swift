//  SavingsListViewModel.swift

import Foundation
import RealmSwift

class SavingsListViewModel: ObservableObject {
    private var realm: Realm
    private var itemResults: Results<SavingsItem>
    @Published var savingsItems: [SavingsItem] = []
    @Published var categories: [Category] = []
    var goalViewModel: GoalViewModel

    init(goalViewModel: GoalViewModel) {
        self.goalViewModel = goalViewModel
        realm = try! Realm()
        itemResults = realm.objects(SavingsItem.self)
        DatabaseManager.shared.setupDefaultCategories()
        loadItems()
        loadCategories()
    }
    
    func loadItems() {
        savingsItems = itemResults.toArray()
    }
    
    func loadCategories() {
        categories = Array(realm.objects(Category.self))
    }
    
    func addSavingsItem(name: String, amount: Double, category: String, memo: String, date: Date) {
        guard let currentGoal = goalViewModel.goal else {
            print("Error: goal is nil when trying to add SavingsItem")
            return
        }
        
        let newItem = SavingsItem()
        newItem.name = name
        newItem.amount = amount
        newItem.category = category.isEmpty ? "未分類" : category
        newItem.memo = memo
        newItem.date = date
        newItem.goalId = currentGoal.id
        
        print("Adding SavingsItem with name: \(name), amount: \(amount), goalId: \(newItem.goalId)")
        
        try! realm.write {
            realm.add(newItem)
            currentGoal.currentSavings += amount
            print("Added SavingsItem: \(newItem.name), new total savings: \(currentGoal.currentSavings)")
        }
        goalViewModel.currentSavings = currentGoal.currentSavings
        goalViewModel.refreshSavingsItems()
    }
    
    func deleteItem(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let item = savingsItems[index]
        
        if let goal = goalViewModel.goal {
            try! realm.write {
                goal.currentSavings -= item.amount
                realm.delete(item)
            }
        }
        
        try! realm.write {
            realm.delete(item)
        }
        loadItems()
        goalViewModel.calculateCurrentSavings()
        goalViewModel.loadSavingsItems()
    }
}
