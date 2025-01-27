//
//  Transaction.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

public struct Transaction: Identifiable, Codable {
    public var id: UUID = UUID()
    public var title: String
    public var remarks : String
    public var amount: Double
    public var dateAdded: Date
    public var category: String
    public var tintColor: String
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        //self.id = id
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    var color: Color {
        return tints.first(where: { $0.color == tintColor})?.value ?? appTintColor
    }
    
    // Sample for previews
    static let sample = Transaction(title: "Sample", remarks: "Sample remarks", amount: 100, dateAdded: Date(), category: .expense, tintColor: .init(color: "blue"))
}
