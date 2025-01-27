import SwiftUI

struct GoalsScreen: View {
    @EnvironmentObject var goalStore: GoalStore
    @EnvironmentObject var transactionStore: TransactionStore
    @EnvironmentObject var appTheme: AppTheme
    @State private var showAddGoal = false
    
    // Calculate savings for the current month
    var currentSavings: Double {
        let now = Date()
        let calendar = Calendar.current
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        let income = transactionStore.transactions.filter { $0.dateAdded >= monthAgo && $0.category == Category.income.rawValue }.map { $0.amount }.reduce(0, +)
        let expense = transactionStore.transactions.filter { $0.dateAdded >= monthAgo && $0.category == Category.expense.rawValue }.map { $0.amount }.reduce(0, +)
        return income - expense
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(red: 243/255, green: 236/255, blue: 255/255).ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("Goals")
                        .font(.title2.bold())
                        .padding(.horizontal,16)
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.vertical,8)
                .padding(.top, 16)
            
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(goalStore.goals) { goal in
                            GoalCard(goal: goal, currentSavings: currentSavings)
                                .contextMenu {
                                    Button("Delete", role: .destructive) {
                                        if let idx = goalStore.goals.firstIndex(where: { $0.id == goal.id }) {
                                            goalStore.goals.remove(at: idx)
                                        }
                                    }
                                }
                        }
                        if goalStore.goals.isEmpty {
                            Text("No goals yet. Tap + to add one!")
                                .foregroundColor(.gray)
                                .padding()
                            
                        }
                        Spacer(minLength: 24)
                    }
                    .padding([.leading, .trailing], 12)
                }
            }
            Button(action: { showAddGoal = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(24)
                    .background(appTheme.accentColor)
                    .clipShape(Circle())
                    .shadow(radius: 6)
            }
            .padding(.trailing, 8)
            .padding(.bottom, 8)
            .sheet(isPresented: $showAddGoal) {
                AddGoalView().environmentObject(goalStore)
            }
        }
    }
}

struct GoalCard: View {
    var goal: Goal
    var currentSavings: Double
    var progress: Double {
        min(max(currentSavings / goal.targetAmount, 0), 1)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                Text(goal.deadline, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            ProgressView(value: progress) {
                Text(String(format: "$%.0f / $%.0f", currentSavings, goal.targetAmount))
                    .font(.caption)
            }
            .accentColor(.purple)
            .padding(.vertical, 4)
            if progress >= 1 {
                Text("Goal reached!")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

struct AddGoalView: View {
    @EnvironmentObject var goalStore: GoalStore
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var targetAmount = ""
    @State private var deadline = Date().addingTimeInterval(60*60*24*30)
    var body: some View {
        ZStack {
            Color(red: 243/255, green: 236/255, blue: 255/255).ignoresSafeArea()
            VStack(spacing: 20) {
                // Top Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2.bold())
                            .foregroundColor(.purple)
                    }
                    Spacer()
                    Text("Add Goal")
                        .font(.title2.bold())
                    Spacer().frame(width: 32)
                }
                .padding(.top, 24)
                .padding(.horizontal)
                // Card-style form
                VStack(spacing: 16) {
                    TextField("Title", text: $title)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    TextField("Target Amount", text: $targetAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                        .padding(.horizontal)
                    Button(action: saveGoal) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(12)
                    }
                    .disabled(title.isEmpty || Double(targetAmount) == nil)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
                Spacer()
            }
        }
    }
    func saveGoal() {
        guard let amount = Double(targetAmount) else { return }
        let goal = Goal(title: title, targetAmount: amount, deadline: deadline)
        goalStore.add(goal)
        dismiss()
    }
}

#Preview {
    GoalsScreen().environmentObject(GoalStore()).environmentObject(TransactionStore()).environmentObject(AppTheme())
} 
