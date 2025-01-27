//
//  Search.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

struct Search: View { // Renamed from ContentView
    @State private var searchText = ""

    let transactions: [Transaction] = [
           Transaction(icon: "M", title: "Magic Keyboard", subtitle: "Apple Product", amount: "₹129.00", date: "11 Dec 2023", color: .purple),
           Transaction(icon: "A", title: "Apple Music", subtitle: "Apple Product", amount: "₹10.99", date: "12 Dec 2023", color: .blue),
           Transaction(icon: "A", title: "Apple iMac", subtitle: "Apple Product", amount: "₹1,40,000", date: "13 Dec 2023", color: .red),
           Transaction(icon: "M", title: "Mac Studio", subtitle: "Apple Product", amount: "₹3,44,000", date: "14 Dec 2023", color: .red),
           Transaction(icon: "M", title: "Mac Mini", subtitle: "Apple Product", amount: "₹1,49,000", date: "15 Dec 2023", color: .red),
           Transaction(icon: "i", title: "iCloud+", subtitle: "Subscription", amount: "₹0.99", date: "11 Dec 2023", color: .red)
       ]
    
    var filteredTransactions: [Transaction] {
        if searchText.isEmpty {
            return transactions
        } else {
            return transactions.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredTransactions, id: \.id) { transaction in
                SearchTransactionRow(
                    icon: transaction.icon,
                    title: transaction.title,
                    subtitle: transaction.subtitle,
                    amount: transaction.amount,
                    date: transaction.date,
                    color: transaction.color
                )
            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchText, prompt: "Search transactions...")
            .navigationTitle("Transactions")
        }
    }
    
    struct Transaction: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let subtitle: String
        let amount: String
        let date: String
        let color: Color
    }
}
    
    
    
    struct SearchTransactionRow: View {
        var icon: String
        var title: String
        var subtitle: String
        var amount: String
        var date: String
        var color: Color
        
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
            }
            .padding(.vertical, 5)
        }
    }
    
    // Transaction Model
    




#Preview {
    Search()
}
