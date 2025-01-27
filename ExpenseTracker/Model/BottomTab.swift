//
//  BottomTab.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

enum BottomTab: String {
    case home = "Home"
    case recents = "Recents"
    case charts = "Charts"
    case search = "Filter"
    case settings = "Settings"
    
    
    @ViewBuilder
    func tabContent() -> some View {
        switch self {
        case .home:
            Image(systemName: "house")
            Text(self.rawValue)
        case .recents:
            Image(systemName: "calendar")
            Text(self.rawValue)
        case .charts:
            Image(systemName: "chart.bar.xaxis")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
            
            
            
        }
    }
}
