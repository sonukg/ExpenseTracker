//
//  Category.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

enum Category: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}
