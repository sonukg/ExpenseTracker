//
//  Settings.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//
import SwiftUI

struct Settings: View {
    @EnvironmentObject var transactionStore: TransactionStore
    @EnvironmentObject var appTheme: AppTheme
    @Environment(\.dismiss) var dismiss
    @State private var showResetAlert = false
    let colorThemes = ["purple", "orange", "blue", "green"]
    
    var body: some View {
        ZStack {
            Color(red: 243/255, green: 236/255, blue: 255/255).ignoresSafeArea()
            VStack(spacing: 24) {
                // Custom Top Bar with Back Arrow
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2.bold())
                            .foregroundColor(appTheme.accentColor)
                    }
                    Spacer()
                    Text("Settings")
                        .font(.title2.bold())
                    Spacer().frame(width: 32) // To balance the back arrow
                }
                .padding(.top, 24)
                .padding(.horizontal)
                VStack(spacing: 16) {
                    // Dark Mode Toggle
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(appTheme.accentColor)
                        Toggle("Dark Mode", isOn: $appTheme.isDarkMode)
                            .toggleStyle(SwitchToggleStyle(tint: appTheme.accentColor))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(14)
                    // Theme Picker
                    HStack {
                        Image(systemName: "paintpalette.fill")
                            .foregroundColor(appTheme.accentColor)
                        Text("Theme Color")
                        Spacer()
                        Picker("Theme", selection: $appTheme.selectedColor) {
                            ForEach(colorThemes, id: \.self) { theme in
                                Text(theme.capitalized).tag(theme)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(14)
                    // Reset Data
                    Button(action: { showResetAlert = true }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(.red)
                            Text("Reset All Data")
                                .foregroundColor(.red)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                    }
                    .alert(isPresented: $showResetAlert) {
                        Alert(title: Text("Reset All Data?"), message: Text("This will delete all transactions."), primaryButton: .destructive(Text("Reset")) {
                            transactionStore.transactions = []
                        }, secondaryButton: .cancel())
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
        }
        .preferredColorScheme(appTheme.isDarkMode ? .dark : .light)
    }
}

#Preview {
    Settings().environmentObject(TransactionStore()).environmentObject(AppTheme())
}
