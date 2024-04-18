//
//  HarryPotterQuizApp.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 15.04.2024.
//

import SwiftUI

@main
struct HarryPotterQuizApp: App {
    @StateObject private var purchase = AppPurchase()
    @StateObject private var gameViewModel = GameViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(purchase)
                .environmentObject(gameViewModel)
                .task {
                    await purchase.loadProducts()
                }
        }
    }
}
