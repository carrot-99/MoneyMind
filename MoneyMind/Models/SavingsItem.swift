//  SavingsItem.swift

import Foundation
import RealmSwift

class SavingsItem: Object {
    @objc dynamic var id = UUID().uuidString // ユニークID
    @objc dynamic var name: String = ""      // アイテム名
    @objc dynamic var amount: Double = 0.0   // 我慢した金額
    @objc dynamic var memo: String?          // メモ
    @objc dynamic var category: String = ""  // カテゴリ
    @objc dynamic var goalId: String = ""    // 関連する目標のID
    @objc dynamic var date: Date = Date()    // 関連する目標のID
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
