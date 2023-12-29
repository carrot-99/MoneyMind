//  SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                // カテゴリを編集へのリンク
                NavigationLink(destination: CategoryEditView(viewModel: CategoryViewModel())) {
                    Text("カテゴリを編集")
                }
                
                // 利用規約へのリンク
                NavigationLink(destination: TermsView()) {
                    Text("利用規約")
                }
                
                // プライバシーポリシーへのリンク
                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("プライバシーポリシー")
                }
            }
            .navigationBarTitle("設定", displayMode: .inline)
            .navigationBarItems(trailing: Button("閉じる") {
                presentationMode.wrappedValue.dismiss()
            })
            .foregroundColor(.blue)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
