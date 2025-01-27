import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var transactionStore: TransactionStore
    @EnvironmentObject var appTheme: AppTheme
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var category: Category = .income
    @State private var tintColor: String = "blue"
    @State private var selectedTab: Category = .income
    
    let colorOptions: [String] = ["blue", "red", "green", "purple", "orange"]
    
    var recentTransactions: [Transaction] {
        Array(transactionStore.transactions.sorted { $0.dateAdded > $1.dateAdded }.prefix(5))
    }
    
    var body: some View {
        ZStack {
            Color(red: 243/255, green: 236/255, blue: 255/255).ignoresSafeArea()
            VStack(spacing: 16) {
                // Top Bar with Close Button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2.bold())
                            .foregroundColor(appTheme.accentColor)
                    }
                    Spacer()
                    Text("Add Transaction")
                        .font(.title2.bold())
                    Spacer().frame(width: 32)
                }
                .padding(.top, 24)
                .padding(.horizontal)
                // Tabs for Add Income / Add Expense
                HStack(spacing: 12) {
                    ForEach(Category.allCases, id: \.self) { cat in
                        Button(action: {
                            selectedTab = cat
                            category = cat
                        }) {
                            HStack {
                                Image(systemName: cat == .income ? "wallet.pass" : "creditcard")
                                Text(cat == .income ? "Add Income" : "Add Expense")
                            }
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == cat ? (cat == .income ? Color.purple.opacity(0.15) : Color.orange.opacity(0.15)) : Color.white)
                            .foregroundColor(selectedTab == cat ? (cat == .income ? .purple : .orange) : .gray)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(selectedTab == cat ? (cat == .income ? Color.purple : Color.orange) : Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal)
                // Form Card
                VStack(spacing: 12) {
                    TextField("Title", text: $title)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    TextField("Remarks", text: $remarks)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .padding(.horizontal)
                    Picker("Color", selection: $tintColor) {
                        ForEach(colorOptions, id: \.self) { color in
                            Text(color.capitalized).tag(color)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    Button(action: saveTransaction) {
                        Text("Add " + (selectedTab == .income ? "Income" : "Expense"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedTab == .income ? Color.purple : Color.orange)
                            .cornerRadius(12)
                    }
                    .disabled(title.isEmpty || amount.isEmpty || Double(amount) == nil)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
                Spacer()
            }
            .padding(.top)
        }
    }
    
    func saveTransaction() {
        guard let amt = Double(amount) else { return }
        let tx = Transaction(title: title, remarks: remarks, amount: amt, dateAdded: date, category: category, tintColor: TintColor(color: tintColor))
        transactionStore.add(tx)
        dismiss()
    }
}

#Preview {
    AddTransactionView().environmentObject(TransactionStore()).environmentObject(AppTheme())
} 