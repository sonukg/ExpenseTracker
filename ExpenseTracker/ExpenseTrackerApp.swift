//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject var transactionStore = TransactionStore()
    @StateObject var appTheme = AppTheme()
    @StateObject var goalStore = GoalStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionStore)
                .environmentObject(appTheme)
                .environmentObject(goalStore)
        }
    }
}
