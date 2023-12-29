// AddSavingsItemView.swift

import SwiftUI

struct AddSavingsItemView: View {
    @ObservedObject var viewModel: SavingsListViewModel
    var onAddComplete: (() -> Void)?
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var memo: String = ""
    @State private var date = Date()
    @State private var showAlert = false
    @State private var errorMessage = ""

    var body: some View {
        Form {
            Section {
                TextField("アイテム名", text: $name)
                TextField("金額", text: $amount)
                TextField("メモ", text: $memo)
                DatePicker("日付", selection: $date, displayedComponents: .date)
            }
            .foregroundColor(.black)
            
            Section {
                Picker("カテゴリ", selection: $category) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Text(category.name).tag(category.name) 
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .foregroundColor(.black)
            
            Section {
                Button("追加") {
                    guard validateInputs() else {
                        showAlert = true
                        return
                    }

                    let amountValue = Double(amount) ?? 0
                    viewModel.addSavingsItem(name: name, amount: amountValue, category: category, memo: memo, date: date)
                    self.presentationMode.wrappedValue.dismiss()
                    onAddComplete?()
                }
            }
            .foregroundColor(.blue)
        }
        .navigationBarTitle("新しい我慢アイテム", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("入力エラー"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            viewModel.loadCategories()
        }
    }
    
    private func validateInputs() -> Bool {
        if name.isEmpty {
            errorMessage = "アイテム名を入力してください。"
            return false
        }

        if amount.isEmpty || Double(amount) == nil {
            errorMessage = "金額を正しく入力してください。"
            return false
        }

        return true
    }
}
