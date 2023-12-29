// MainView.swift

import SwiftUI
import RealmSwift

struct MainView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var showingSettings = false
    @State private var showingAddItemView = false
    
    let goalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    let itemDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: GoalView(viewModel: viewModel)) {
                HStack {
                    Text(viewModel.goal?.name ?? "目標未設定")
                        .font(.title)
                    Spacer()
                    VStack {
                        Text(viewModel.goal?.date != nil ? goalDateFormatter.string(from: viewModel.goal!.date!) : "達成日未設定")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("¥\(Int(viewModel.currentSavings)) / ¥\(Int(viewModel.goal?.amount ?? 0))")
                    }
                }
            }
            .padding()

            ProgressBar(progress: viewModel.progress)
                .frame(height: 20)
            
            HStack {
                Text("我慢リスト")
                    .font(.headline)
                    .padding(.leading)
                Spacer()
                Button(action: {
                    showingAddItemView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .sheet(isPresented: $showingAddItemView) {
                AddSavingsItemView(viewModel: SavingsListViewModel(goalViewModel: viewModel), onAddComplete: {
                    viewModel.refreshSavingsItems()
                })
            }

            ScrollView {
                ForEach(viewModel.savingsItems, id: \.id) { item in
                    NavigationLink(destination: SavingsDetailView(item: item)) {
                        HStack {
                            Text(itemDateFormatter.string(from: item.date))
                            Text(item.name)
                            Spacer()
                            Text("¥\(Int(item.amount))")
                        }
                        .padding()
                        .background(Color(red: 44 / 255, green: 44 / 255, blue: 46 / 255))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                        .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 0, y: 2)
                    }
                }
                .padding()
            }

            Spacer()
        }
        .navigationBarItems(leading: Button(action: {
            showingSettings = true
        }) {
            Image(systemName: "gear")
                .imageScale(.large)
        })
        .fullScreenCover(isPresented: $showingSettings) { 
            SettingsView()
        }
        .onAppear() {
            viewModel.loadGoal()
            viewModel.loadSavingsItems()
        }
        .background(Color(red: 44 / 255, green: 44 / 255, blue: 46 / 255))
        .foregroundColor(.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: GoalViewModel())
    }
}
