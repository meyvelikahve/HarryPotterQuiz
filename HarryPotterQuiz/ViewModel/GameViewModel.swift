//
//  GameViewModel.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 18.04.2024.
//

import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var recentScores = [0,0,0]
    
    private var allQuestions: [Question] = []
    private var answeredQuestions : [Int] = []
    
    var filteredQuestions: [Question] = []
    var currentQuestion = Constants.previewQuestion
    
    var answers: [String] = []
    
    var correctAnswer : String{
        currentQuestion.answers.first(where: {$0.value == true})!.key
    }
    
    init() {
        decodeQuestions()
    }
    
    func startGame(){
        gameScore = 0
        questionScore = 5
        answeredQuestions = []
    }
    
    func filterQuestions(to books: [Int]){
        filteredQuestions = allQuestions.filter {books.contains($0.book)}
    }
    
    func newQuestion(){
        if filteredQuestions.isEmpty {return}
        
        if answeredQuestions.count == filteredQuestions.count {
            answeredQuestions = []
        }
        
        var potentionQuestion = filteredQuestions.randomElement()!
        
        while answeredQuestions.contains(potentionQuestion.id){
            potentionQuestion = filteredQuestions.randomElement()!
        }
        currentQuestion = potentionQuestion
        
        answers = []
        
        for answer in currentQuestion.answers.keys{ // answers are dictonary
            answers.append(answer)
        }
        
        answers.shuffle()
        
        questionScore = 5
    }
    
    func correct(){
        answeredQuestions.append(currentQuestion.id)
        withAnimation {
            gameScore += questionScore
        }
        
    }
    
    func endGame(){
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
    }
    
    private func decodeQuestions(){
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json"){
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                allQuestions = try decoder.decode([Question].self, from: data)
                
                filteredQuestions = allQuestions
            } catch{
                print("Error decoding JSON data : \(error)")
            }
        }
    }
}
