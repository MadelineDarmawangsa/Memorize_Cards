//
//  MemoryGame.swift
//  Memorize
//
//  Created by Madeline Darmawangsa on 27/05/22.
//

import Foundation
import SwiftUI


struct MemoryGame<CardContent> where CardContent : Equatable {
    private(set) var cards : Array<Card>
    private var OneAndOnlyFaceUpCardIndex : Int?
    var score : Int = 0 //please make priv without error
    var theme: String = "food"
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = OneAndOnlyFaceUpCardIndex {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 4
                } else {
                    if cards[chosenIndex].seenBefore {
                        score -= 1
                    } else {
                        cards[chosenIndex].seenBefore = true
                    }
                    if cards[potentialMatchIndex].seenBefore {
                        score -= 1
                    } else {
                        cards[potentialMatchIndex].seenBefore = true
                    }
                }
                OneAndOnlyFaceUpCardIndex = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                OneAndOnlyFaceUpCardIndex = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    
    
    init(numberOfPairsOfCards : Int, createCardContent : (Int) -> CardContent, theme: Theme) {
        OneAndOnlyFaceUpCardIndex = nil
        score = 0
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content : CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    struct Theme {
        let name : String
        let themeEmojis : [CardContent]
        var numPairs : Int
        var cardColors : Color
    }
    
    struct Card : Identifiable {
        var isFaceUp: Bool = false {
                    didSet {
                        if isFaceUp {
                            startUsingBonusTime()
                        } else {
                            stopUsingBonusTime()
                        }
                    }
                }
                var isMatched: Bool = false {
                    didSet {
                        stopUsingBonusTime()
                    }
                }
        var seenBefore = false
        var content : CardContent
        var id: Int
        
        
        // MARK: - Bonus Time
                
                // this could give matching bonus points
                // if the user matches the card
                // before a certain amount of time passes during which the card is face up
                
                // can be zero which means "no bonus available" for this card
                var bonusTimeLimit: TimeInterval = 10
                
                // how long this card has ever been face up
                private var faceUpTime: TimeInterval {
                    if let lastFaceUpDate = self.lastFaceUpDate {
                        return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
                    } else {
                        return pastFaceUpTime
                    }
                }
                // the last time this card was turned face up (and is still face up)
                var lastFaceUpDate: Date?
                // the accumulated  time yhis card has been face up in the past
                // (i.e. not including the current time it`s been face up if it is currently so)
                var pastFaceUpTime: TimeInterval = 0
                
                // how much time left before the bonus opportunity runs out
                var bonusTimeRemaining: TimeInterval {
                    max(0, bonusTimeLimit - faceUpTime)
                }
                // percentage of the bonus time remaining
                var bonusRemaining: Double {
                    (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
                }
                // whether the card was matched during the bonus time period
                var hasEarnedBonus: Bool {
                    isMatched && bonusTimeRemaining > 0
                }
                // whether we are currently face up, unmatched and have not yet used up the bonus window
                var isConsumingBonusTime: Bool {
                    isFaceUp && !isMatched && bonusTimeRemaining > 0
                }
                
                // called when the card transitions to face up state
                private mutating func startUsingBonusTime() {
                    if isConsumingBonusTime, lastFaceUpDate == nil {
                        lastFaceUpDate = Date()
                    }
                }
                // called when the card goes back face down (or gets matched)
                private mutating func stopUsingBonusTime() {
                    pastFaceUpTime = faceUpTime
                    self.lastFaceUpDate = nil
                }
            }
    }




struct Previews_MemoryGame_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
