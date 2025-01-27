//
//  TintColor.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

struct TintColor: Identifiable {
    var id:UUID = .init()
    var color:String
    var value:Color
    
}

var tints: [TintColor] = [
    .init(color: "red", value: .red),
    .init(color: "green", value: .green),
    .init(color: "blue", value: .blue),
    .init(color: "yellow", value: .yellow),
    .init(color: "purple", value: .purple),
    .init(color: "pink", value: .pink),
    .init(color: "brown", value: .brown)
    ]
