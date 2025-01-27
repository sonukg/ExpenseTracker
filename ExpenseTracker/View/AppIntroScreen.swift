//
//  AppIntroScreen.swift
//  ExpenseTracker
//
//  Created by sonukg on 27/01/25.
//

import SwiftUI

struct AppIntroScreen: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
        var body: some View{
        VStack(spacing:15){
            
            Text("What's new in the Expense Tracker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top,65)
                .padding(.bottom,35)
            
            VStack(alignment: .leading,spacing: 25, content:{
                PointView(symbl: "rupeesign", title: "Transaction", subtitle: "Keep track your earnings and expenses")
                
                PointView(symbl: "chart.bar.fill", title: "Visual Charts", subtitle: "Keep track your earnings and expenses in eye catching charts")

                
                PointView(symbl: "magnifyingglass", title: "Advanced Search", subtitle: "Anvanced search to find your expenses and earnings")

            
            })
            .frame(maxWidth:.infinity,alignment: .leading)
            .padding(.horizontal,15)
            
            Spacer(minLength: 10)
            
            Button(action: {
                isFirstTime = false
            },label: {
                Text("Continue")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity, minHeight: 60)                     .background(.blue, in: .rect(cornerRadius: 12))
                        .contentShape(.rect)
            })
            
        }.padding(.horizontal,20)
    
    }
    
    @ViewBuilder
    func PointView(symbl:String,title:String, subtitle:String) -> some View{
        HStack(spacing: 20){
            Image(systemName: symbl)
                .foregroundStyle(appTintColor.gradient )
                .font(.largeTitle)
                .frame(width: 45, height: 30)
                            
            VStack(alignment: .leading, spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .foregroundStyle(.gray)
                    
            })
        }
        
        
    }
}

#Preview {
    AppIntroScreen()
}
