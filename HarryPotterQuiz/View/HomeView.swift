//
//  ContentView.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 15.04.2024.
//

import SwiftUI
import AVKit

struct HomeView: View {
    @EnvironmentObject private var appPurchase : AppPurchase
    @EnvironmentObject private var gameViewModel : GameViewModel
    
    @State private var audioPlayer: AVAudioPlayer!
    
    @State private var scalePlayButton = false
    @State private var moveBackgroundImage = false
    
    @State private var animateViewsIn = false
    
    @State private var showInstructions = false
    @State private var showSettings = false
    @State private var playGame = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top, 3)
                    .offset(x: moveBackgroundImage ? geo.size.width / 1.1 : -geo.size.width / 1.1)
                    .onAppear{
                        withAnimation(.easeInOut(duration: 60).repeatForever()){
                            moveBackgroundImage.toggle()
                        }
                    }
                
                VStack{
                    VStack{
                        if animateViewsIn {
                            VStack{
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                
                                Text("Harry Potter")
                                    .font(.custom(Constants.hpFont, size: 70))
                                    .padding(.bottom, -30)
                                
                                Text("Book Quiz")
                                    .font(.custom(Constants.hpFont, size: 50))
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                    }
                    .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                    
                    Spacer()
                    
                   
                    
                    VStack {
                        if false {
                            VStack{
                                Text("Recent Scores")
                                    .font(.title2)
                                
                                Text("33")
                                Text("27")
                                Text("15")
                            }
                            .font(.title3)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.7))
                            .cornerRadius(15)
                            .transition(.opacity)
                        }
                    }
                    .animation(.linear(duration: 1).delay(3), value: animateViewsIn)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Group {
                            if animateViewsIn {
                                Button{
                                    showInstructions.toggle()
                                } label: {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                            .transition(.offset(x: -geo.size.width/4))
                            .sheet(isPresented: $showInstructions, content: {
                                InstructionsView()
                        
                            })
                            }
                            
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Button{
                                    filterQuestions()
                                    gameViewModel.startGame()
                                    playGame.toggle()
                                } label: {
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 50)
                                        .background(appPurchase.books.contains(.active) ? .brown : .gray)
                                        .cornerRadius(7)
                                        .shadow(radius: 5)
                                }
                                .scaleEffect(scalePlayButton ? 1.2 : 1)
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                                        scalePlayButton.toggle()
                                    }
                                }
                                .transition(.offset(y: geo.size.height/3))
                                .fullScreenCover(isPresented: $playGame, content: {
                                    GameplayView()
                                        .environmentObject(gameViewModel)
                                })
                                .disabled(appPurchase.books.contains(.active) ? false : true)
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        
                        Spacer()
                        
                        
                        Group {
                            if animateViewsIn {
                                Button{
                                    showSettings.toggle()
                                    
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: geo.size.width / 4))
                                .sheet(isPresented: $showSettings, content: {
                                    SettingView()
                                        .environmentObject(appPurchase)
                                })
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        
                        
                        Spacer()
                    }
                    .frame(width: geo.size.width)
                    
                    VStack{
                        if animateViewsIn {
                            if appPurchase.books.contains(.active) == false {
                                Text("No questions available. Go settings and choice a book.")
                                    .multilineTextAlignment(.center)
                                    .transition(.opacity)
                                    .padding(.horizontal,30)
                            }
                        }
                    }
                    .animation(.easeInOut.delay(3), value: animateViewsIn)
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear{
            animateViewsIn = true
            // playAudio()
            
        }
    }
    
    private func playAudio(){
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    private func filterQuestions(){
        var books : [Int] = []
        
        for (index, status) in appPurchase.books.enumerated(){
            if status == .active {
                books.append(index+1)
            }
        }
        
        gameViewModel.filterQuestions(to: books)
        
        gameViewModel.newQuestion()
    }
}

#Preview {
    HomeView()
        .environmentObject(AppPurchase())
        .environmentObject(GameViewModel())
}
