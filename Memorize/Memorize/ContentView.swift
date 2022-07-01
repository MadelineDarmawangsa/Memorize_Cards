//
//  ContentView.swift
//  randomTest
//
//  Created by Madeline Darmawangsa on 26/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel : EmojiMemoryGame
    @State var emojis = ["✈️","🚌","🚔","🚑","🚜","🛵","🚗","🛻","⛵️","🛳","🛶","🚂","🚅","🚠","🚀","🚛","🏎"]
    var vehicleEmojis = ["✈️","🚌","🚔","🚑","🚜","🛵","🚗","🛻","⛵️","🛳","🛶","🚂","🚅","🚠","🚀","🚛","🏎"]
    var faceEmojis = ["😃","😎","😖","🥸","😤","😱","🤩","🤣","🤓","🥰","😗","🥲","🤑","🤭","🤐","🤨","😣"]
    var foodEmojis = ["🥯","🍳","🥨","🍖","🍏","🍉","🌭","🍊","🍍","🥪","🍲","🥘","🍱","🍩","🍧","🍿","🥘"]
    @State var numCards = 10
    var body: some View {
        VStack {
            HStack {
                Text("Score: ") + Text(String(viewModel.score))
                Spacer()
                ZStack {
                    newGameButton
                    RoundedRectangle(cornerRadius: 10).stroke().frame(width: 95, height: 40)
                }
            }.foregroundColor(.blue)
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid (columns : [GridItem(.adaptive(minimum: 75))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card : card).aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                print(card)
                                viewModel.choose(card)
                            }
                    }
                }
            }
        }.padding()
    }
    
    var newGameButton : some View {
        Button {
            startNewGame()
        } label: {
            Text("New Game")
        }
    }
    private func startNewGame() {
        withAnimation(.easeInOut){
            viewModel.startNewGame()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game).preferredColorScheme(.light)
        ContentView(viewModel: game).preferredColorScheme(.dark)
    }  
}
struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }.foregroundColor(.red)
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)
                .transition(.identity)
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
            }.rotation3DEffect(Angle(degrees: card.isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .animation(.spring(), value: card.isFaceUp)
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}
