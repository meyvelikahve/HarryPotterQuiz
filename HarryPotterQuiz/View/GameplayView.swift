//
//  GameplayView.swift
//  HarryPotterQuiz
//
//  Created by Recep Sevim on 17.04.2024.
//

import SwiftUI
import AVKit

struct GameplayView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var gameViewModel: GameViewModel
    
    @Namespace private var namespace
    
    @State private var musicPlayer : AVAudioPlayer!
    @State private var sfxPlayer : AVAudioPlayer!
    
    @State private var animateViewsIn = false
    
    @State private var tappedCorrectAnswer = false
    @State private var hintWiggle = false
    
    @State private var scaleNextButton = false
    @State private var movePointsToScore = false
    
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var wrongAnswersTapped : [Int] = []
    
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack{
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
                    .overlay(Rectangle().foregroundColor(.black.opacity(0.8)))
                
                VStack{
                    // MARK: Controlls
                    HStack{
                        Button("End Game"){
                            gameViewModel.endGame()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))
                        Spacer()
                        Text("Score: \(gameViewModel.gameScore)")
                    }
                    .padding()
                    .padding(.vertical, 30)
                    
                    // MARK: Question
                    VStack {
                        if animateViewsIn {
                            Text(gameViewModel.currentQuestion.question)
                                .font(.custom(Constants.hpFont, size: 50))
                                .multilineTextAlignment(.center)
                            .padding()
                            .transition(.scale)
                            .opacity(tappedCorrectAnswer ? 0.1 : 1)
                        }
                    }
                    .animation(.easeInOut(duration: animateViewsIn ? 2 : 0), value: animateViewsIn)

                    
                    Spacer()
                    
                    // MARK: Hints
                    HStack {
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundColor(.cyan)
                                    .rotationEffect(.degrees(hintWiggle ? -13 : -17))
                                    .padding()
                                    .padding(.leading, 20)
                                    .transition(.offset(x: -geo.size.width / 2))
                                    .onAppear{
                                        withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()) {
                                            hintWiggle = true}
                                    }
                                    .onTapGesture {
                                        withAnimation (.easeOut(duration: 1)){
                                            revealHint = true
                                        }
                                        
                                        playSfxSound(name: "page-flip")
                                        gameViewModel.questionScore -= 1
                                    }
                                    .rotation3DEffect(
                                        .degrees(revealHint ? 180 : 0),
                                        axis: (x: 0.0, y: 1.0, z: 0.0)
                                    )
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .opacity(revealHint ? 0 : 1)
                                    .offset(x: revealHint ? geo.size.width / 2 : 0)
                                    .overlay(
                                        Text(gameViewModel.currentQuestion.hint)
                                            .padding(.leading, 33)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .opacity(revealHint ? 1 : 0)
                                            .scaleEffect(revealHint ? 1.33 : 1)
                                    )
                                    .opacity(tappedCorrectAnswer ? 0 : 1)
                                    .disabled(tappedCorrectAnswer)
                            }
                        }
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ?  2 : 0), value: animateViewsIn)
                        Spacer()
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundColor(.black)
                                    .frame(width: 100,height: 100)
                                    .background(.cyan)
                                    .cornerRadius(20)
                                    .rotationEffect(.degrees(hintWiggle ? 13 : 17))
                                    .padding()
                                .padding(.trailing, 20)
                                .transition(.offset(x: geo.size.width / 2))
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()) {
                                        hintWiggle = true
                                    }
                                }
                                .onTapGesture {
                                    withAnimation (.easeOut(duration: 1)){
                                        revealBook = true
                                    }
                                    
                                    playSfxSound(name: "page-flip")
                                    gameViewModel.questionScore -= 1
                                }
                                .rotation3DEffect(
                                    .degrees(revealBook ? 180 : 0),
                                    axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                                .scaleEffect(revealBook ? 5 : 1)
                                .opacity(revealBook ? 0 : 1)
                                .offset(x: revealBook ? -geo.size.width / 2 : 0)
                                .overlay(
                                    Image("hp\(gameViewModel.currentQuestion.book)")
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(3)
                                        .padding(.trailing, 33)
                                        .padding(.bottom, 10)
                                        .opacity(revealBook ? 1 : 0)
                                        .scaleEffect(revealBook ? 1.33 : 1)
                                        
                                )
                                .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                .disabled(tappedCorrectAnswer)
                                
                            }
                        }
                        .animation(.easeOut(duration:animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                    }
                    .padding(.bottom)
                    
                    // MARK: Answers
                    LazyVGrid(columns: [GridItem(),GridItem()], content: {
                        ForEach (Array(gameViewModel.answers.enumerated()), id: \.offset) { index, answer in
                            if gameViewModel.currentQuestion.answers[answer] == true {
                                VStack {
                                    if animateViewsIn {
                                        if tappedCorrectAnswer == false {
                                            Text(answer)
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .padding(10)
                                                .frame(width: geo.size.width / 2.15, height: 80)
                                                .background(.green.opacity(0.5))
                                                .cornerRadius(25)
                                                .transition(.asymmetric(insertion: .scale, removal: .scale(scale: 5).combined(with: .opacity.animation(.easeOut(duration: 0.5)))))
                                                .matchedGeometryEffect(id: "answer", in: namespace)
                                                .onTapGesture {
                                                    withAnimation(.easeOut(duration: 1)){
                                                        tappedCorrectAnswer = true
                                                        
                                                    }
                                                    
                                                    playSfxSound(name: "magic-wand")
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5
                                                    ){
                                                        gameViewModel.correct()
                                                    }
                                                }
                                        }
                                    }
                                }
                                .animation(.easeIn(duration:animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            }
                            else {
                                VStack {
                                    if animateViewsIn {
                                        Text(answer)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .padding(10)
                                            .frame(width: geo.size.width / 2.15, height: 80)
                                            .background(wrongAnswersTapped.contains(index) ? .red.opacity(0.5): .green.opacity(0.5))
                                            .cornerRadius(25)
                                            .transition(.scale)
                                            .onTapGesture {
                                                withAnimation(.easeOut(duration: 1)){
                                                    wrongAnswersTapped.append(index)
                                                }
                                                
                                                playSfxSound(name: "negative-beeps")
                                                gameViewModel.questionScore -= 1
                                            }
                                            .scaleEffect(wrongAnswersTapped.contains(index) ? 0.8 : 1)
                                            .disabled(tappedCorrectAnswer || wrongAnswersTapped.contains(index))
                                            .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    }
                                }
                                .animation(.easeIn(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            }
                        }
                    })
                    
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .foregroundColor(.white)
                
                // MARK: Celebration
                VStack{
                    Spacer()
                    VStack{
                        if tappedCorrectAnswer {
                            Text("\(gameViewModel.questionScore)")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .transition(.offset(y: -geo.size.height / 4))
                                .offset(x: movePointsToScore ? geo.size.width / 2.3 : 0, y: movePointsToScore ? -geo.size.height / 13 : 0)
                                .opacity(movePointsToScore ? 0 : 1)
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 1).delay(3)){
                                        movePointsToScore = true
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut(duration: 1).delay(2), value: tappedCorrectAnswer)
                    
                    Spacer()
                    
                    VStack{
                        if tappedCorrectAnswer {
                            Text("Brilliant!")
                                .font(.custom(Constants.hpFont, size: 100))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height / 2)))
                        }
                    }
                    .animation(.easeInOut(duration:tappedCorrectAnswer ? 1 : 0).delay(tappedCorrectAnswer ? 1 : 0), value: tappedCorrectAnswer)
                    
                    Spacer()
                    
                    if tappedCorrectAnswer {
                        Text(gameViewModel.correctAnswer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .frame(width: geo.size.width / 2.15, height: 80)
                            .background(.green.opacity(0.5))
                            .cornerRadius(25)
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: "answer", in: namespace)
                    }
                    
                    Group {
                        Spacer()
                    }
                    Spacer()
                    
                    VStack{
                        if tappedCorrectAnswer {
                            Button("Next Level"){
                                animateViewsIn = false
                                tappedCorrectAnswer = false
                                revealBook = false
                                revealHint = false
                                movePointsToScore = false
                                wrongAnswersTapped = []
                                
                                gameViewModel.newQuestion()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    animateViewsIn = true
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .font(.largeTitle)
                            .transition(.offset(y: geo.size.height / 3))
                            .scaleEffect(scaleNextButton ? 1.2 : 1)
                            .onAppear{
                                withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                                    scaleNextButton.toggle()
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration:tappedCorrectAnswer ? 2.7 : 1).delay(tappedCorrectAnswer ? 2.7 : 0),value: tappedCorrectAnswer)
                    
                    Group {
                        Spacer()
                        Spacer()
                    }
                    
                }
                .foregroundColor(.white)
                
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear{
            animateViewsIn = true
           // playMusic()
        }
    }
    
    private func playMusic(){
        let sounds = ["let-the-mystery-unfold", "spellcraft", "hiding-place-in-the-forest","deep-in-the-dell"]
        let index = Int.random(in: 0...(sounds.count - 1))
        let sound = Bundle.main.path(forResource: sounds[index], ofType: "mp3")
        
        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        musicPlayer.volume = 0.1
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
    }
    
    private func playSfxSound(name: String){
        let sound = Bundle.main.path(forResource: name, ofType: "mp3")
        
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        
        sfxPlayer.play()
    }
   
}

#Preview {
    GameplayView()
        .environmentObject(GameViewModel())
}
