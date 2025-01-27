//
//  Search.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

struct Search: View {
    @EnvironmentObject var transactionStore: TransactionStore
    @EnvironmentObject var appTheme: AppTheme
    @State private var searchText = ""

    var filteredTransactions: [Transaction] {
        if searchText.isEmpty {
            return transactionStore.transactions
        } else {
            return transactionStore.transactions.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.remarks.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        ZStack {
            Color(red: 243/255, green: 236/255, blue: 255/255).ignoresSafeArea()
            VStack(spacing: 16) {
                // Top Bar (fixed)
                HStack {
                    Text("Search Transactions")
                        .font(.title2.bold())
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical,8)
                .padding(.top, 16)
                // Prominent search bar (fixed)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.horizontal,8)
                    TextField("Search transactions...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(8)
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                // Scrollable content
                ScrollView(showsIndicators: false) {
                    VStack(spacing:0) {
                        ForEach(filteredTransactions, id: \.id) { transaction in
                            SearchTransactionRow(
                                icon: String(transaction.title.prefix(1)),
                                title: transaction.title,
                                subtitle: transaction.remarks,
                                amount: String(format: "₹%.2f", transaction.amount),
                                date: transaction.dateAdded.toFormattedString(),
                                color: transaction.color,
                                isIncome: transaction.category == Category.income.rawValue
                            )
                            .padding(.vertical, 16)
                            .padding(.horizontal)
                            if transaction.id != filteredTransactions.last?.id {
                                Divider().padding(.leading, 60)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
                    Spacer(minLength: 24)
                }
            }
        }
    }

    struct SearchTransactionRow: View {
        var icon: String
        var title: String
        var subtitle: String
        var amount: String
        var date: String
        var color: Color
        var isIncome: Bool
        var body: some View {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                    .overlay(Text(icon).foregroundColor(.white))
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(amount)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isIncome ? .purple : .yellow)
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    Search().environmentObject(TransactionStore()).environmentObject(AppTheme())
}
