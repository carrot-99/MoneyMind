//  CategoryEditSheet.swift

import SwiftUI

struct CategoryEditSheet: View {
    @Binding var isPresented: Bool
    @State var categoryName: String = ""
    var onSave: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("カテゴリ名", text: $categoryName)
                    .autocapitalization(.none)
                    .foregroundColor(.black)
            }
            .navigationBarItems(leading: Button("キャンセル") {
                isPresented = false
            }, trailing: Button("保存") {
                onSave(categoryName)
                isPresented = false
            })
            .navigationBarTitle("カテゴリを編集", displayMode: .inline)
        }
        .foregroundColor(.blue)
    }
}
