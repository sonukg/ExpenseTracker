//
//  Home.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var transactionStore: TransactionStore
    @EnvironmentObject var appTheme: AppTheme
    @State private var showAddSheet = false
    @State private var showSettings = false
    
    var totalIncome: Double {
        transactionStore.transactions.filter { $0.category == Category.income.rawValue }.map { $0.amount }.reduce(0, +)
    }
    var totalExpense: Double {
        transactionStore.transactions.filter { $0.category == Category.expense.rawValue }.map { $0.amount }.reduce(0, +)
    }
    var balance: Double { totalIncome - totalExpense }
    
    var recentTransactions: [Transaction] {
        Array(transactionStore.transactions.sorted { $0.dateAdded > $1.dateAdded }.prefix(5))
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(red: 243/255, green: 236/255, blue: 255/255).ignoresSafeArea()
            VStack(spacing: 0) {
                // Top Bar (fixed)
                HStack {
                    Spacer()
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }.padding(.horizontal,12)
                        .padding(.vertical, 4)
                }
                .padding(.horizontal, 4)
                .padding(.top, 24)
                // Scrollable content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Gradient Card
                        ZStack(alignment: .topTrailing) {
                            LinearGradient(gradient: Gradient(colors: [appTheme.accentColor, appTheme.accentColor.opacity(0.7), .orange.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                .frame(height: 140)
                                .cornerRadius(24)
                                .shadow(radius: 8)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Total Balance")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.8))
                                    Spacer()
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Text(String(format: "$%.2f", balance))
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }
                        // Income/Expense Summary Cards
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Income")
                                    .font(.caption)
                                    .foregroundColor(appTheme.accentColor)
                                Text(String(format: "$%.2f", totalIncome))
                                    .font(.title2.bold())
                                    .foregroundColor(appTheme.accentColor)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Expenses")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Text(String(format: "$%.2f", totalExpense))
                                    .font(.title2.bold())
                                    .foregroundColor(.orange)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 2)
                        .padding(.vertical, 4)
                        // Transactions List
                        HStack {
                            Text("Transactions")
                                .font(.headline)
                            Spacer()
                            Button("See All") {}
                                .font(.caption)
                                .foregroundColor(appTheme.accentColor)
                        }
                        .padding(.horizontal, 4)
                        VStack(spacing: 0) {
                            ForEach(recentTransactions) { tx in
                                HStack(spacing: 20) {
                                    Circle()
                                        .fill(tx.color)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "creditcard")
                                                .foregroundColor(.white)
                                        )
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(tx.title)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        Text(tx.dateAdded, style: .time)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text(String(format: "%@%.0f", tx.category == Category.income.rawValue ? "+$" : "-$", abs(tx.amount)))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(tx.category == Category.income.rawValue ? .purple : .yellow)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 16)
                                if tx.id != recentTransactions.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(18)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        .padding(.bottom, 8)
                        .padding(.top, 8)
                        Spacer(minLength: 24)
                    }
                    .padding([.leading, .trailing], 12)
                }
            }
            // Floating Add Button
            Button(action: { showAddSheet = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(24)
                    .background(appTheme.accentColor)
                    .clipShape(Circle())
                    .shadow(radius: 6)
            }
            .padding(.trailing, 8)
            .padding(.bottom, 8)
            .sheet(isPresented: $showAddSheet) {
                AddTransactionView().environmentObject(transactionStore).environmentObject(appTheme)
            }
            .sheet(isPresented: $showSettings) {
                Settings().environmentObject(transactionStore).environmentObject(appTheme)
            }
        }
    }
}

#Preview {
    Home().environmentObject(TransactionStore()).environmentObject(AppTheme())
}
