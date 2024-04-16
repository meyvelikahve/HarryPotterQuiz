//
//  InfoBackgroundImage.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 16.04.2024.
//

import SwiftUI

struct InfoBackgroundImage : View {
    var body: some View{
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

#Preview {
    InfoBackgroundImage()
}
