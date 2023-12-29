//  GoalView.swift

import Foundation
import SwiftUI

struct GoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var showAlert = false
    @State private var errorMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("目標設定")) {
                TextField("目標名", text: $viewModel.name)
                TextField("目標金額", value: $viewModel.amount, formatter: NumberFormatter())
                DatePicker("達成予定日", selection: $viewModel.date, displayedComponents: .date)
            }
            
            Section {
                Button("目標を保存") {
                    if validateInputs() {
                        viewModel.saveGoal()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showAlert = true
                    }
                }
            }
        }
        .navigationBarTitle("目標を設定", displayMode: .inline)
        .onAppear() {
            viewModel.loadGoal()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("入力エラー"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateInputs() -> Bool {
        if viewModel.name.isEmpty {
            errorMessage = "目標名を入力してください。"
            return false
        }

        if viewModel.amount <= 0 {
            errorMessage = "目標金額を正しく入力してください（0より大きい数）。"
            return false
        }

        return true
    }
}
