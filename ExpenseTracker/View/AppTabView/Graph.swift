//
//  Graph.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct Graph: View {
    @EnvironmentObject var transactionStore: TransactionStore
    @State private var selectedPeriod: String = "Monthly"
    let periods = ["Daily", "Weekly", "Monthly"]
    
    // Filtered transactions based on selected period
    var filteredTransactions: [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        switch selectedPeriod {
        case "Weekly":
            if let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) {
                return transactionStore.transactions.filter { $0.dateAdded >= weekAgo }
            }
            return []
        case "Monthly":
            if let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) {
                return transactionStore.transactions.filter { $0.dateAdded >= monthAgo }
            }
            return []
        default:
            return transactionStore.transactions
        }
    }
    var totalIncome: Double {
        filteredTransactions.filter { $0.category == Category.income.rawValue }.map { $0.amount }.reduce(0, +)
    }
    var totalExpense: Double {
        filteredTransactions.filter { $0.category == Category.expense.rawValue }.map { $0.amount }.reduce(0, +)
    }
    
    // Grouped data for chart
    var chartData: [(label: String, income: Double, expense: Double)] {
        let calendar = Calendar.current
        switch selectedPeriod {
        case "Daily":
            // Group by hour for today
            let hours = (0..<24).map { $0 }
            return hours.map { hour in
                let label = String(format: "%02d:00", hour)
                let income = filteredTransactions.filter {
                    calendar.component(.hour, from: $0.dateAdded) == hour && $0.category == Category.income.rawValue
                }.map { $0.amount }.reduce(0, +)
                let expense = filteredTransactions.filter {
                    calendar.component(.hour, from: $0.dateAdded) == hour && $0.category == Category.expense.rawValue
                }.map { $0.amount }.reduce(0, +)
                return (label, income, expense)
            }
        case "Weekly":
            // Group by day for the last 7 days
            let days = (0..<7).map { i in calendar.date(byAdding: .day, value: -i, to: Date())! }.reversed()
            let formatter = DateFormatter(); formatter.dateFormat = "dd MMM"
            return days.map { day in
                let label = formatter.string(from: day)
                let income = filteredTransactions.filter {
                    calendar.isDate($0.dateAdded, inSameDayAs: day) && $0.category == Category.income.rawValue
                }.map { $0.amount }.reduce(0, +)
                let expense = filteredTransactions.filter {
                    calendar.isDate($0.dateAdded, inSameDayAs: day) && $0.category == Category.expense.rawValue
                }.map { $0.amount }.reduce(0, +)
                return (label, income, expense)
            }
        case "Monthly":
            // Group by week for the last month
            let weeks = (0..<4).map { i in i }
            let formatter = DateFormatter(); formatter.dateFormat = "dd MMM"
            return weeks.map { week in
                let weekStart = Calendar.current.date(byAdding: .day, value: week * 7, to: Date().startOfMonth())!
                let weekEnd = Calendar.current.date(byAdding: .day, value: (week + 1) * 7 - 1, to: Date().startOfMonth())!
                let label = formatter.string(from: weekStart)
                let income = filteredTransactions.filter {
                    $0.dateAdded >= weekStart && $0.dateAdded <= weekEnd && $0.category == Category.income.rawValue
                }.map { $0.amount }.reduce(0, +)
                let expense = filteredTransactions.filter {
                    $0.dateAdded >= weekStart && $0.dateAdded <= weekEnd && $0.category == Category.expense.rawValue
                }.map { $0.amount }.reduce(0, +)
                return (label, income, expense)
            }
        default:
            return []
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 243/255, green: 236/255, blue: 255/255).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                // Top Bar
                HStack {
                    Text("Overview")
                        .font(.title2.bold())
                    Spacer()
                }
                // Pie Chart Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Income vs Expense")
                        .font(.headline)
                    PieChartView(income: totalIncome, expense: totalExpense)
                        .frame(height: 180)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                .padding(.horizontal,1)
                // Summary Cards
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Income")
                            .font(.caption)
                            .foregroundColor(.purple)
                        Text(String(format: "$%.0f", totalIncome))
                            .font(.title2.bold())
                            .foregroundColor(.purple)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Expenses")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text(String(format: "$%.0f", totalExpense))
                            .font(.title2.bold())
                            .foregroundColor(.yellow)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                }
                // Segmented Control
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(periods, id: \.self) { period in
                        Text(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                // Statistics Line Chart
                VStack(alignment: .leading) {
                    Text("Statistics")
                        .font(.headline)
#if canImport(Charts)
                    Chart {
                        ForEach(Array(chartData.enumerated()), id: \.offset) { idx, data in
                            LineMark(
                                x: .value("Label", data.label),
                                y: .value("Income", data.income)
                            )
                            .foregroundStyle(.purple)
                            .symbol(Circle())
                            .annotation(position: .top) {
                                if data.income > 0 {
                                    Text(String(format: "$%.0f", data.income))
                                        .font(.caption2)
                                        .foregroundColor(.purple)
                                        .padding(4)
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(6)
                                }
                            }
                            LineMark(
                                x: .value("Label", data.label),
                                y: .value("Expense", data.expense)
                            )
                            .foregroundStyle(.yellow)
                            .symbol(Circle())
                            .annotation(position: .top) {
                                if data.expense > 0 {
                                    Text(String(format: "$%.0f", data.expense))
                                        .font(.caption2)
                                        .foregroundColor(.yellow)
                                        .padding(4)
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    .frame(height: 160)
#else
                    // Simple custom line chart fallback
                    SimpleLineChart(data: chartData)
                        .frame(height: 160)
#endif
                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                Spacer()
            }
            .padding()
        }
    }
}

extension Date {
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
}

#Preview {
    Graph().environmentObject(TransactionStore())
}

#if !canImport(Charts)
struct SimpleLineChart: View {
    let data: [(label: String, income: Double, expense: Double)]
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Income line
                Path { path in
                    for (i, point) in data.enumerated() {
                        let x = geo.size.width * CGFloat(i) / CGFloat(max(data.count-1, 1))
                        let y = geo.size.height * (1 - CGFloat(point.income / (maxIncome ?? 1)))
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.purple, lineWidth: 2)
                // Expense line
                Path { path in
                    for (i, point) in data.enumerated() {
                        let x = geo.size.width * CGFloat(i) / CGFloat(max(data.count-1, 1))
                        let y = geo.size.height * (1 - CGFloat(point.expense / (maxExpense ?? 1)))
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.yellow, lineWidth: 2)
            }
        }
    }
    var maxIncome: Double? { data.map { $0.income }.max() }
    var maxExpense: Double? { data.map { $0.expense }.max() }
}
#endif
