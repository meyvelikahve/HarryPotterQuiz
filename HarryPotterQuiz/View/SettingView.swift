//
//  SettingView.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 16.04.2024.
//

import SwiftUI


struct SettingView: View {
    @EnvironmentObject private var appPurchase: AppPurchase

    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            
            VStack{
                Text("Which books would you like to see question from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                
                ScrollView{
                    LazyVGrid(columns: [GridItem(), GridItem()], content: {
                        
                        ForEach(0..<7){ index in
                            if appPurchase.books[index] == .active || (appPurchase.books[index] == .locked && appPurchase.purchasedIDs.contains("hp\(index+1)")){
                                ZStack(alignment: .bottomTrailing){
                                    Image("hp\(index+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.green)
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .task{
                                    appPurchase.books[index] = .active
                                }
                                .onTapGesture {
                                    appPurchase.books[index] = .inactive
                                }
                                
                            } else if appPurchase.books[index] == .inactive {
                                ZStack(alignment: .bottomTrailing){
                                    Image("hp\(index+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.33))
                                    
                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.green.opacity(0.5))
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    appPurchase.books[index] = .active
                                    
                                }
                            } else {
                                ZStack{
                                    Image("hp\(index+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.75))
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .shadow(color: .white.opacity(0.75), radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture{
                                    let product = appPurchase.products[index-3]
                                    
                                    Task {
                                        await appPurchase.purchase(product)
                                    }
                                }
                            }
                            
                        }
                    })
                    .padding()
                }
                Button("Done"){
                    dismiss()
                }
                .doneButton()
            }
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(AppPurchase())
}
