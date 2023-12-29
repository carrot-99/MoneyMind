//  Goal.swift

import Foundation
import RealmSwift

// Goalクラスは、ユーザーの目標を表します。
class Goal: Object {
    // プロパティ
    @objc dynamic var id = UUID().uuidString // ユニークID
    @objc dynamic var name: String = ""      // 目標の名前
    @objc dynamic var amount: Double = 0.0   // 目標金額
    @objc dynamic var date: Date?            // 達成予定日
    @objc dynamic var currentSavings: Double = 0.0 // 現在の貯金額
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func progress() -> Double {
        let progress = currentSavings / amount
        return progress > 1.0 ? 1.0 : progress 
    }
}
