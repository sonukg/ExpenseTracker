//
//  Recents.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

struct Recents: View {
    @EnvironmentObject var transactionStore: TransactionStore
    @State private var selectedPeriod: String = "Daily"
    let periods = ["Daily", "Weekly", "Monthly"]
    @State private var showAddSheet: Bool = false
    
    // Filtered transactions based on selected period
    var filteredTransactions: [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        switch selectedPeriod {
        case "Daily":
            return transactionStore.transactions.filter { calendar.isDate($0.dateAdded, inSameDayAs: now) }
        case "Weekly":
            if let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) {
                return transactionStore.transactions.filter { $0.dateAdded >= weekAgo }
            }
            return []
        case "Monthly":
            if let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) {
                return transactionStore.transactions.filter { $0.dateAdded >= monthAgo }
            }
            return []
        default:
            return transactionStore.transactions
        }
    }
    var income: Double { filteredTransactions.filter { $0.category == Category.income.rawValue }.map { $0.amount }.reduce(0, +) }
    var expense: Double { filteredTransactions.filter { $0.category == Category.expense.rawValue }.map { $0.amount }.reduce(0, +) }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(red: 243/255, green: 236/255, blue: 255/255).ignoresSafeArea()
            VStack(spacing: 0) {
                // Top Bar (fixed)
                HStack {
                    Text("Recents")
                        .padding(.horizontal,16)
                        .font(.title2.bold())
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.top, 32)
                // Segmented Control (fixed)
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(periods, id: \.self) { period in
                        Text(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 16)
                .padding(.top, 16)
                // Scrollable content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Pie Chart Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Income vs Expense")
                                .font(.headline)
                            PieChartView(income: income, expense: expense)
                                .frame(height: 180)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(18)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.top, 16)
                        // Transactions List
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Transactions")
                                .font(.headline)
                                .padding(.all, 8)
                                .padding(.horizontal)
                            ForEach(filteredTransactions) { tx in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(tx.color)
                                        .frame(width: 36, height: 36)
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
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                if tx.id != filteredTransactions.last?.id {
                                    Divider().padding(.leading, 60)
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(18)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                        Spacer(minLength: 24)
                    }
                }
            }
            // Floating Add Button
            Button(action: { showAddSheet = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(24)
                    .background(Color.purple)
                    .clipShape(Circle())
                    .shadow(radius: 6)
            }
            .padding(.trailing, 8)
            .padding(.bottom, 8)
            .sheet(isPresented: $showAddSheet) {
                AddTransactionView().environmentObject(transactionStore)
            }
        }
    }
}

#Preview {
    Recents().environmentObject(TransactionStore())
}
