import SwiftUI

public struct PieChartView: View {
    public var income: Double
    public var expense: Double
    public init(income: Double, expense: Double) {
        self.income = income
        self.expense = expense
    }
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                if income + expense == 0 {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(Text("No Data").font(.caption))
                } else {
                    PieSlice(startAngle: .degrees(0), endAngle: .degrees(360 * (income / (income + expense))))
                        .fill(Color.purple)
                    PieSlice(startAngle: .degrees(360 * (income / (income + expense))), endAngle: .degrees(360))
                        .fill(Color.orange)
                }
            }
        }
    }
}

public struct PieSlice: Shape {
    public var startAngle: Angle
    public var endAngle: Angle
    public init(startAngle: Angle, endAngle: Angle) {
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle - .degrees(90), endAngle: endAngle - .degrees(90), clockwise: false)
        path.closeSubpath()
        return path
    }
} 
