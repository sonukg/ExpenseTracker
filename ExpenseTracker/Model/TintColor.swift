//
//  TintColor.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

struct TintColor: Identifiable, Codable {
    var id: UUID = .init()
    var color: String
    
    var value: Color {
        switch color {
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "yellow": return .yellow
        case "purple": return .purple
        case "pink": return .pink
        case "brown": return .brown
        default: return .blue
        }
    }
    
    init(color: String) {
        self.color = color
    }
    // Needed for decoding
    enum CodingKeys: String, CodingKey {
        case color
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        color = try container.decode(String.self, forKey: .color)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(color, forKey: .color)
    }
}

let tints: [TintColor] = [
    .init(color: "red"),
    .init(color: "green"),
    .init(color: "blue"),
    .init(color: "yellow"),
    .init(color: "purple"),
    .init(color: "pink"),
    .init(color: "brown")
]
