//
//  Recents.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

struct Recents: View {
    
    @State private var selectedStartDate: Date = Date()
    @State private var selectedEndDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var showDatePicker: Bool = false
    @State private var selectedTab: String = "Expense"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Welcome Message
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Date Range Selector
            Button(action: {
                showDatePicker.toggle() // Opens DatePicker
            }) {
                Text("\(selectedStartDate.toFormattedString()) - \(selectedEndDate.toFormattedString())")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .underline()
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    Text("Select Date Range")
                        .font(.headline)
                        .padding()
                    
                    DatePicker("Start Date", selection: $selectedStartDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                    
                    DatePicker("End Date", selection: $selectedEndDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                    
                    Button("Done") {
                        showDatePicker = false
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            
            // Balance Summary Card
            VStack(spacing: 5) {
                Text("₹-2,059.00")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                HStack {
                    VStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.green)
                        Text("Income")
                            .font(.caption)
                        Text("₹2,039")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.red)
                        Text("Expense")
                            .font(.caption)
                        Text("₹4,098")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical,5)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            
            // Tabs (Income | Expense)
            HStack {
                Button(action: { selectedTab = "Income" }) {
                    Text("Income")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTab == "Income" ? Color.gray.opacity(0.3) : Color.clear)
                        .cornerRadius(10)
                }
                
                Button(action: { selectedTab = "Expense" }) {
                    Text("Expense")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTab == "Expense" ? Color.gray.opacity(0.3) : Color.clear)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            
            // Recent Transactions List
            
            List {
                TransactionRow(icon: "M", title: "Magic Keyboard", subtitle: "Apple Product", amount: "₹129.00", date: "11 Dec 2023", color: .purple)
                TransactionRow(icon: "A", title: "Apple Music", subtitle: "Subscription", amount: "₹10.99", date: "11 Dec 2023", color: .blue)
                TransactionRow(icon: "i", title: "iCloud+", subtitle: "Subscription", amount: "₹0.99", date: "11 Dec 2023", color: .red)
                TransactionRow(icon: "i", title: "iCloud+", subtitle: "Subscription", amount: "₹0.99", date: "11 Dec 2023", color: .red)
                TransactionRow(icon: "i", title: "iCloud+", subtitle: "Subscription", amount: "₹0.99", date: "11 Dec 2023", color: .red)
                TransactionRow(icon: "i", title: "iCloud+", subtitle: "Subscription", amount: "₹0.99", date: "11 Dec 2023", color: .red)
            }
            .listStyle(PlainListStyle())
            .frame(maxHeight: .infinity)
        }
        .padding()
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}

// ✅ Date Extension to Fix Formatting Issue
extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy" // Example: "23 Dec 23"
        return formatter.string(from: self)
    }
}

// Transaction Row Component
struct TransactionRow: View {
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

// ✅ Fixed Preview Name
struct RecentsPreview: PreviewProvider {
    static var previews: some View {
        Recents()
    }
}
