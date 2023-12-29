//  TermsAndPrivacyAgreementView.swift

import SwiftUI

struct TermsAndPrivacyAgreementView: View {
    @Binding var isShowingTerms: Bool
    @Binding var hasAgreedToTerms: Bool
    @State private var isShowingTermsView = false
    @State private var isShowingPrivacyPolicyView = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 20)
                    Text("本アプリでは、お客様の体験を向上させるために広告を表示します。詳細については、以下の利用規約とプライバシーポリシーをご確認ください。")
                        .font(.subheadline)
                        .padding(.horizontal)

                    HStack {
                        Spacer()
                        
                        Button("利用規約") {
                            isShowingTermsView = true
                        }
                        .sheet(isPresented: $isShowingTermsView) {
                            TermsView()
                        }

                        Spacer()

                        Button("プライバシーポリシー") {
                            isShowingPrivacyPolicyView = true
                        }
                        .sheet(isPresented: $isShowingPrivacyPolicyView) {
                            PrivacyPolicyView()
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
            }

            Button("同意する") {
                UserDefaults.standard.set(true, forKey: "hasAgreedToTerms")
                self.hasAgreedToTerms = true
                self.isShowingTerms = false
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color(red: 44 / 255, green: 44 / 255, blue: 46 / 255)) // 背景色をここに適用
        .foregroundColor(.white)
    }
}
