//
//  SettingView.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 16.04.2024.
//

import SwiftUI

enum BookStatus {
    case active
    case inactive
    case locked
}

struct SettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
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
                            if books[index] == .active {
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
                                .onTapGesture {
                                    books[index] = .inactive
                                }
                            } else if books[index] == .inactive {
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
                                    books[index] = .active
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
}
