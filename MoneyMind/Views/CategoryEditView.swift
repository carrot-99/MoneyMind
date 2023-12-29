//  CategoryEditView.swift

import SwiftUI

struct CategoryEditView: View {
    @ObservedObject var viewModel: CategoryViewModel
    @State private var showingEditSheet = false
    @State private var editCategoryName = ""
    @State private var categoryToEdit: Category?

    var body: some View {
        List {
            ForEach(viewModel.categories, id: \.id) { category in
                Text(category.name)
                    .onTapGesture {
                        self.categoryToEdit = category
                        self.editCategoryName = category.name
                        self.showingEditSheet = true
                    }
            }
            .onDelete(perform: viewModel.safeDeleteCategory)
        }
        .foregroundColor(.black)
        .navigationBarItems(trailing: Button(action: {
            self.categoryToEdit = nil
            self.editCategoryName = ""
            self.showingEditSheet = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(.blue)
        })
        .sheet(isPresented: $showingEditSheet) {
            CategoryEditSheet(isPresented: $showingEditSheet, categoryName: editCategoryName) { newName in
                if let category = categoryToEdit {
                    viewModel.updateCategory(category: category, newName: newName)
                } else {
                    viewModel.addCategory(name: newName)
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("削除エラー"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("カテゴリ一覧")
    }
}
