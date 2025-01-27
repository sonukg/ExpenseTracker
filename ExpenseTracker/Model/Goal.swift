import Foundation

struct Goal: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var targetAmount: Double
    var deadline: Date
    var isCompleted: Bool = false
} 