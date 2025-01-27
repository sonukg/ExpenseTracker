//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var activeTb: BottomTab = .home
    @StateObject private var transactionStore = TransactionStore()
    @StateObject private var appTheme = AppTheme()
    @StateObject private var goalStore = GoalStore()
    var body: some View {
        TabView(selection: $activeTb) {
            Home().environmentObject(transactionStore).environmentObject(appTheme)
                .tag(BottomTab.home)
                .tabItem{BottomTab.home.tabContent()}
            
            Recents().environmentObject(transactionStore).environmentObject(appTheme)
                .tag(BottomTab.recents)
                .tabItem{BottomTab.recents.tabContent()}
            
            Graph().environmentObject(transactionStore).environmentObject(appTheme)
                .tag(BottomTab.charts)
                .tabItem{BottomTab.charts.tabContent()}
            
            Search().environmentObject(transactionStore).environmentObject(appTheme)
                .tag(BottomTab.search)
                .tabItem{BottomTab.search.tabContent()}
            
            GoalsScreen().environmentObject(goalStore).environmentObject(transactionStore).environmentObject(appTheme)
                .tag(BottomTab.goals)
                .tabItem{BottomTab.goals.tabContent()}
            
        }.sheet(isPresented: $isFirstTime, content: {
            AppIntroScreen()
                .interactiveDismissDisabled()
        })
          
    }
}

#Preview {
    ContentView()
}
