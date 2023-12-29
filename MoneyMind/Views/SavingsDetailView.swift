//  SavingsDetailView.swift

import SwiftUI
import RealmSwift

struct SavingsDetailView: View {
    @ObservedObject var viewModel: SavingsDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(item: SavingsItem) {
        self.viewModel = SavingsDetailViewModel(item: item)
    }
    
    var body: some View {
        Form {
            Section(header: Text("アイテム詳細")) {
                TextField("アイテム名", text: $viewModel.name)
                TextField("金額", value: $viewModel.amount, formatter: NumberFormatter())
                TextField("メモ", text: $viewModel.memo)
                Picker("カテゴリ", selection: $viewModel.category) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                DatePicker("日付", selection: $viewModel.date, displayedComponents: .date)
            }
            
            Section {
                Button("変更を保存") {
                    viewModel.saveChanges()
                    presentationMode.wrappedValue.dismiss()
                }
                
                Button("削除", role: .destructive) {
                    viewModel.deleteItem()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            viewModel.loadCategories()
        }
        .navigationBarTitle("アイテム詳細", displayMode: .inline)
    }
}
