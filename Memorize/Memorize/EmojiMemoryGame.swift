//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Madeline Darmawangsa on 27/05/22.
//

import Foundation
import SwiftUI



class EmojiMemoryGame : ObservableObject{
    
    static let emojis = ["✈️","🚌","🚔","🚑","🚜","🛵","🚗","🛻"]
    static let vehicleEmojis = ["✈️","🚌","🚔","🚑","🚜","🛵","🚗","🛻"]
    static let faceEmojis = ["😃","😎","😖","🥸","😤","😱","🤩"]
    static let foodEmojis = ["🥯","🍳","🥨","🍖","🍏","🍉","🌭"]
    static let themeNames = ["vehicle", "face", "food"]
    @State var cardColors = getColor("red")
    
    static let colors = ["black", "gray", "red", "green", "blue", "orange","yellow", "pink", "purple"]
    
    static func getColor(_ chosenColor : String) -> Color {
        switch chosenColor {
        case "black":
            return .black
        case "gray":
            return .gray
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "orange":
            return .orange
        case "yellow":
            return .yellow
        case "pink":
            return .pink
        case "purple":
            return .purple
        default:
            return .red
        }
        
    }
    
    static func createMemoryGame() -> MemoryGame<String> {
        let randomTheme = themeNames.randomElement()
        var randomEmojis : [String] = vehicleEmojis
        var cardColor : String = "red"
        if randomTheme=="vehicle" {
            randomEmojis = vehicleEmojis
            cardColor = "blue"
        } else if randomTheme=="food" {
            randomEmojis = foodEmojis
            cardColor = "red"
        } else if randomTheme == "face" {
            randomEmojis = faceEmojis
            cardColor = "pink"
        }
        var newTheme =  createTheme(themeName: randomTheme!, theEmojis: faceEmojis, cardColors: getColor(cardColor))
        return MemoryGame<String>(numberOfPairsOfCards: 6, createCardContent : {pairIndex in randomEmojis[pairIndex]}, theme:newTheme)
    }
    
    static func createTheme(themeName: String, theEmojis : [String], cardColors : Color) -> MemoryGame<String>.Theme {
        MemoryGame<String>.Theme(name: themeName, themeEmojis: theEmojis.shuffled(), numPairs: 6, cardColors: cardColors)
    }
    
    @Published private var model : MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    var cards : Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var score : Int {
        return model.score
    }
    


    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}

