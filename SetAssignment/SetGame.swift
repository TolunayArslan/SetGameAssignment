//
//  Set.swift
//  SetAssignment
//
//  Created by Arslan, Tolunay on 04.11.19.
//  Copyright © 2019 Arslan, Tolunay. All rights reserved.
//

import Foundation

/// The game Set and his logic
struct SetGame {
   
    
    // MARK: Properties
    
    /// The score of the player.
    var score = 0
    
    /// The deck of the game and it's logic.
    var deck = Deck()
    
    
    /// The indexes of all selected cards.
    var indexOfSelectedCards: [Int] {
        var indexes = [Int]()
        for card in playingCards {
            if card.isSelected {
                let index = playingCards.firstIndex(of: card)!
                indexes += [index]
            }
        }
        return indexes
    }
    
    /// The indexes of all matched cards.
    var indexOfMatchedCards: [Int] {
        var indexes = [Int]()
        for card in playingCards {
            if card.isMatched {
                let index = playingCards.firstIndex(of: card)!
                indexes += [index]
            }
        }
        return indexes
    }
    
    /// The cards which are displayed on the UI.
    var playingCards = [Card]()
    
    // MARK: Actions
    /// Sets the isMatched property of the currently selected Cards to true
     mutating func markCardsMatched() {
        for index in indexOfSelectedCards {
            playingCards[index].isMatched = true
            
        }
    }
    
    /// Sets the isSelected property of all Cards to false
    mutating func deselectCards() {
        for index in playingCards.indices {
            playingCards[index].isSelected = false
        }
    }
    
    private func isThereAMatch() -> Bool {
        var sumNumber = 0
        var sumColor = 0
        var sumShade = 0
        var sumSymbol = 0
        for index in indexOfSelectedCards {
            sumNumber += playingCards[index].matrix.number
            sumColor += playingCards[index].matrix.color
            sumShade += playingCards[index].matrix.shade
            sumSymbol += playingCards[index].matrix.symbol
        }
        if sumNumber % 3 == 0 && sumColor % 3 == 0 && sumShade % 3 == 0 && sumSymbol % 3 == 0 {
            return true
        } else {
            return false
        }
    }
    
    
    /// Selects the card and return true if there is a match, false if there is a mismatch, and nil if there were no cards to check.
    mutating func selectCard(at index: Int) -> Bool? {
        if indexOfSelectedCards.count == 2, !indexOfSelectedCards.contains(index) {
            // Check for Match
            playingCards[index].isSelected = true
            if isThereAMatch() {
                
                return true
            } else {
                return false
            }
        } else {
            // select card           
            playingCards[index].isSelected = (!playingCards[index].isSelected)
            return nil
        }
    }
    
    mutating func replaceCard(at index: Int) {
        
        if let card = deck.dealCard() {
            playingCards[index] = card
        }
    }
    
    
    mutating func deal3Cards() -> Bool {
        guard deck.deckOfCards.count >= 3 else { return false }
        guard playingCards.count < 24 else { return false }
        for _ in 1...3 {
            playingCards += [deck.dealCard()!]
        }
        return true
    }
    
    // MARK: Initialization
    
    init() {
        playingCards = []
        score = 0
        deck = Deck()
        
        for _ in 1...12 {
            playingCards += [deck.dealCard()!]
        }
    }
    
}

struct Card: Equatable {
    
    enum AvailableOption: Int {
        case one = 1
        case two
        case three
    }
    
    // MARK: Properties
    
    var isSelected = false
    var isMatched = false
    var misMatched = false
    var matrix: (number: Int, color: Int,shade: Int,symbol: Int)
    
    var number: AvailableOption
    var color: AvailableOption
    var shade: AvailableOption
    var symbol: AvailableOption
    
    // MARK: Actions
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.matrix == rhs.matrix
    }

    // MARK: Initialization
    
    init(number: Int, color: Int, shade: Int, symbol: Int) {
        
        // TODO: Some guard statement for init maybe
        self.number = AvailableOption.init(rawValue: number)!
        self.color = AvailableOption.init(rawValue: color)!
        self.shade = AvailableOption.init(rawValue: shade)!
        self.symbol = AvailableOption.init(rawValue: symbol)!
        
        matrix = (number, color, shade, symbol)
    }
    
}

struct Deck {
    
    var deckOfCards = [Card]()
    
    mutating func dealCard() -> Card? {
        guard deckOfCards.count >= 1 else { return nil }
       
        return deckOfCards.remove(at: 0)
    }
    
    init() {
        deckOfCards = []
        
        for first in 1...3 {
            for second in 1...3 {
                for third in 1...3 {
                    for fourth in 1...3 {
                        deckOfCards += [Card(number: first, color: second, shade: third, symbol: fourth)]
                    }
                }
            }
        }
        
        // MARK: Shuffle Cards
        for _ in 0..<81 {
                   let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
                   deckOfCards.append(deckOfCards.remove(at: randomIndex))
               }
      
    }
    
    
}
