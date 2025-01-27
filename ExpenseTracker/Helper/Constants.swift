//
//  Constant.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//
import SwiftUI

let appTintColor: Color = .blue
let kTransactionsKey = "transactions_key"

class AppTheme: ObservableObject {
    @Published var isDarkMode: Bool = false
    @Published var selectedColor: String = "purple"
    
    var accentColor: Color {
        switch selectedColor {
        case "purple": return .purple
        case "orange": return .orange
        case "blue": return .blue
        case "green": return .green
        default: return .purple
        }
    }
}

let colorThemes = ["purple", "orange", "blue", "green"]

extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy"
        return formatter.string(from: self)
    }
}


