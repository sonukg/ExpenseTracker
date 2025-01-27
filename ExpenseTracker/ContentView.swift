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
    var body: some View {
        TabView(selection: $activeTb) {
            Home()
                .tag(BottomTab.home)
                .tabItem{BottomTab.home.tabContent()}
            
            Recents()
                .tag(BottomTab.recents)
                .tabItem{BottomTab.recents.tabContent()}
            
            Graph()
                .tag(BottomTab.charts)
                .tabItem{BottomTab.charts.tabContent()}
            
            Search()
                .tag(BottomTab.search)
                .tabItem{BottomTab.search.tabContent()}
            
            Settings()
                .tag(BottomTab.settings)
                .tabItem{BottomTab.settings.tabContent()}
            
        }.sheet(isPresented: $isFirstTime, content: {
            AppIntroScreen()
                .interactiveDismissDisabled()
        })
          
    }
}

#Preview {
    ContentView()
}
