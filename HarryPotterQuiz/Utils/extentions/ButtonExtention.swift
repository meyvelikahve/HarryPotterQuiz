//
//  ButtonExtention.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 16.04.2024.
//

import SwiftUI

extension Button{
    func doneButton() -> some View {
        self
            .font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundColor(.white)
    }
}
