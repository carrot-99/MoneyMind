//  GoalViewModel.swift

import Foundation
import RealmSwift
import Combine

class GoalViewModel: ObservableObject {
    private var realm: Realm
    private var goalResults: Results<Goal>
    private var savingsItemsResults: Results<SavingsItem>
    var progress: Double {
        guard let goalAmount = goal?.amount, goalAmount > 0 else { return 0 }
        return currentSavings / goalAmount
    }

    @Published var name = ""
    @Published var amount: Double = 0
    @Published var date = Date()
    @Published var goal: Goal?
    @Published var savingsItems: [SavingsItem] = []
    @Published var currentSavings: Double = 0.0

    init() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {
                    
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config

        realm = try! Realm(configuration: config)
        goalResults = realm.objects(Goal.self)
        savingsItemsResults = realm.objects(SavingsItem.self)

        createDefaultCategories()
        loadGoal()
        loadSavingsItems()
    }
    
    private func createDefaultCategories() {
//        let defaultCategories = ["衣服", "食費", "趣味", "ショッピング", "嗜好品"]
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
    
    func refreshSavingsItems() {
        loadSavingsItems()
        DispatchQueue.main.async {
            self.updateCurrentSavingsBasedOnItems()
        }
    }
    
    func updateCurrentSavingsBasedOnItems() {
        if let currentGoal = goal {
            let newTotalSavings = calculateCurrentSavings()
            updateCurrentSavings(goal: currentGoal, newSavings: newTotalSavings)
        }
    }
    
    func calculateCurrentSavings() -> Double {
        if let currentGoal = goal {
            let items = realm.objects(SavingsItem.self).filter("goalId == %@", currentGoal.id)
            let totalSavings = items.sum(ofProperty: "amount") as Double
            updateCurrentSavings(goal: currentGoal, newSavings: totalSavings)
            return totalSavings
        }
        return 0
    }

    func updateCurrentSavings(goal: Goal, newSavings: Double) {
        do {
            try realm.write {
                goal.currentSavings = newSavings
            }
            DispatchQueue.main.async {
                self.currentSavings = newSavings
                
            }
        } catch {
            print("Failed to write to Realm: \(error)")
        }
    }
    
    func loadGoal() {
        if let currentGoal = goalResults.first {
            goal = currentGoal
            name = currentGoal.name
            amount = currentGoal.amount
            date = currentGoal.date ?? Date()
            self.currentSavings = currentGoal.currentSavings
            updateCurrentSavingsBasedOnItems()
            print("Loaded goal: \(currentGoal)")
        } else {
            let newGoal = Goal()
            newGoal.name = name
            newGoal.amount = amount
            newGoal.date = date
            try! realm.write {
                realm.add(newGoal)
            }
            goal = newGoal
            self.currentSavings = 0.0
            updateCurrentSavingsBasedOnItems()
        }
    }
    
    func saveGoal() {
        try! realm.write {
            if let existingGoal = goal {
                existingGoal.name = name
                existingGoal.amount = amount
                existingGoal.date = date
            } else {
                let newGoal = Goal()
                newGoal.name = name
                newGoal.amount = amount
                newGoal.date = date
                realm.add(newGoal)
                goal = newGoal
            }
        }
    }
    
    func loadSavingsItems() {
        let sortedItems = savingsItemsResults.sorted(byKeyPath: "date", ascending: false)
        savingsItems = Array(sortedItems)
    }
    
    func deleteItem(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let item = savingsItems[index]
        try! realm.write {
            realm.delete(item)
        }
        loadSavingsItems()
        DispatchQueue.main.async {
            self.updateCurrentSavingsBasedOnItems()
        }
    }
}
