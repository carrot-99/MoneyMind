//  ContentView.swift

import SwiftUI

struct ContentView: View {
    var goalViewModel = GoalViewModel()
    var savingsListViewModel: SavingsListViewModel
    @State private var isShowingTerms = true
    @State private var hasAgreedToTerms = UserDefaults.standard.bool(forKey: "hasAgreedToTerms")
    
    init() {
        self.savingsListViewModel = SavingsListViewModel(goalViewModel: goalViewModel)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                if hasAgreedToTerms {
                    MainView(viewModel: goalViewModel)
                        .onAppear {
                            savingsListViewModel.goalViewModel = goalViewModel
                        }
                    
                    AdMobBannerView()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        .background(Color.gray.opacity(0.1))
                } else {
                    TermsAndPrivacyAgreementView(isShowingTerms: $isShowingTerms, hasAgreedToTerms: $hasAgreedToTerms)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

