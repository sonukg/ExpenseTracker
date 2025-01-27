//
//  Settings.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//
import SwiftUI

// Enum for different themes
enum Theme: String, CaseIterable, Identifiable {
    case system = "System Default"
    case light = "Light Mode"
    case dark = "Dark Mode"

    var id: String { self.rawValue }
}

struct Settings: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .system

    

       var body: some View {
           VStack(alignment: .leading, spacing: 10) {
               Text("Settings") // Explicit title
                   .font(.title)
                   .bold()
                   .padding(.leading)

               Form {
                   Section(header: Text("").font(.headline)) {
                       Toggle("Dark Mode", isOn: $isDarkMode)
                   }
               }
           }
           .navigationBarTitleDisplayMode(.inline) // Ensures title shows
           .preferredColorScheme(isDarkMode ? .dark : .light)
           
              
       }
    
              
}



#Preview {
    Settings()
}
