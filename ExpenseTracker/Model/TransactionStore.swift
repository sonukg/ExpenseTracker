import Foundation
import SwiftUI

class TransactionStore: ObservableObject {
    @Published var transactions: [Transaction] = [] {
        didSet {
            saveTransactions()
        }
    }
    
    init() {
        loadTransactions()
    }
    
    func add(_ transaction: Transaction) {
        transactions.append(transaction)
    }
    
    func update(_ transaction: Transaction) {
        if let idx = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[idx] = transaction
        }
    }
    
    func delete(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
    }
    
    private func saveTransactions() {
        if let data = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(data, forKey: kTransactionsKey)
        }
    }
    
    private func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: kTransactionsKey),
           let saved = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = saved
        }
    }
} 