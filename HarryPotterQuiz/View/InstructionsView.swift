//
//  InstructionsView.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 15.04.2024.
//

import SwiftUI

struct InstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            
            VStack{
                Image("appiconwithradius")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                ScrollView{
                    Text("How To Play")
                        .font(.largeTitle)
                        .padding()
                    
                    VStack(alignment: .leading, content: {
                        Text("Welcome to Harry Potter Book Quiz. In this game, you will be asked random questions from the Harry Potter books and you must guess the right answer or you will lose points!😱")
                            .padding([.horizontal, .bottom])
                        
                        Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                            .padding([.horizontal, .bottom])
                        
                        Text("If you are struggling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using these also minuses 1 point each.")
                            .padding([.horizontal, .bottom])
                        
                        Text("When you select the correct anwer, you will be awarded all the points left for that question and they will be added to your total score.")
                            .padding(.horizontal)
                        
                    })
                    .font(.title3)
                }
                .foregroundColor(.black)
                
                Button("Done"){
                    dismiss()
                }
                .doneButton()
            }
        }
    }
}

#Preview {
    InstructionsView()
}
