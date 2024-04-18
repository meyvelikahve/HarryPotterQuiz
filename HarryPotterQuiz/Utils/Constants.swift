//
//  Constants.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 15.04.2024.
//

import Foundation


enum Constants {
    static let hpFont = "PartyLetPlain"
    
    static let previewQuestion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
}


