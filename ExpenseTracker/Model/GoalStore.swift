import Foundation

class GoalStore: ObservableObject {
    @Published var goals: [Goal] = [] {
        didSet { saveGoals() }
    }
    let key = "goals_key"
    init() { loadGoals() }
    func add(_ goal: Goal) { goals.append(goal) }
    func update(_ goal: Goal) {
        if let idx = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[idx] = goal
        }
    }
    func delete(at offsets: IndexSet) { goals.remove(atOffsets: offsets) }
    private func saveGoals() {
        if let data = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    private func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([Goal].self, from: data) {
            goals = saved
        }
    }
} 