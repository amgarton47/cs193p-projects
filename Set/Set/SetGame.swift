//
//  SetGame.swift
//  Set
//
//  Created by Aidan Garton on 12/19/24.
//

import Foundation

// A representation of the game Set, complete with its game logic and initialization
struct SetGame {
    private(set) var deck: [Card] = []
    private(set) var displayedCards: [Card] = []
    private(set) var selectedCards: [Card] = []
    private(set) var isMatch = false
    private(set) var firstVisibleSet : (Card, Card, Card)?
    
    init() {
        generateDeck()
        deck = deck.shuffled()
        displayedCards.append(contentsOf: deck[0..<12])
        deck.removeFirst(12)
    }
    
    // Displays three new cards to the user.
    // Replaces the cards in a matching set if one is selected
    mutating func deal3Cards() {
        if deck.count >= 3 {
            if isMatch {
                isMatch = false
                
                for idx in displayedCards.indices {
                    if selectedCards.contains(displayedCards[idx]) {
                        displayedCards[idx] = deck[0]
                        deck.removeFirst()
                    }
                }
                selectedCards.removeAll()
            } else {
                displayedCards.append(contentsOf: deck[0..<3])
                deck.removeFirst(3)
            }
        } else if isMatch {
            displayedCards.removeAll(where: { selectedCards.contains($0) })
        }
    }
    
    // provides the logic for when a card is selected (i.e. tapped)
    // sets card as selected and updates isMatch accordingly
    mutating func choose(_ card: Card) {
        if selectedCards.count <= 2 {
            if selectedCards.contains(card) {
                selectedCards.removeAll(where: {$0 == card})
            } else {
                selectedCards.append(card)
                
                if selectedCards.count == 3 {
                    isMatch = isValidSet(selectedCards[0], selectedCards[1], selectedCards[2])
                }
            }
        } else {
            if isMatch {
                deal3Cards()
                selectedCards.removeAll()
            } else {
                selectedCards.removeAll()
                selectedCards.append(card)
            }
        }
    }
    
    mutating func getHint(){
        getFirstVisibleSet()
        
        if let firstVisibleSet {
            selectedCards.removeAll()
            selectedCards.append(firstVisibleSet.0)
            selectedCards.append(firstVisibleSet.1)
            selectedCards.append(firstVisibleSet.2)
            isMatch = true
        }
    }
    
    // returns weather or not a given three cards form a valid set
    private func isValidSet(_ c1: Card, _ c2: Card, _ c3: Card) -> Bool {
        func propIsAllSameOrAllDifferent<T: Equatable>(_ a: T, _ b: T, _ c: T) -> Bool {
            return (a == b && b == c) || (a != b && b != c && a != c)
        }
        
        return propIsAllSameOrAllDifferent(c1.color, c2.color, c3.color) &&
        propIsAllSameOrAllDifferent(c1.number, c2.number, c3.number) &&
        propIsAllSameOrAllDifferent(c1.shading, c2.shading, c3.shading) &&
        propIsAllSameOrAllDifferent(c1.symbol, c2.symbol, c3.symbol)
    }
    
    // generates the 81 unique cards for the game Set from its 4 distinct properties
    private mutating func generateDeck() {
        for num in 1...3 {
            for symbol in Symbol.allCases {
                for shading in Shading.allCases {
                    for color in SetColor.allCases {
                        let id = "\(num) \(symbol) \(shading) \(color)"
                        deck.append(Card(color: color, symbol: symbol, shading: shading, number: num, id: id))
                    }
                }
            }
        }
    }
    
    // Of the displayed cards, calculate the first valid set and save it in global var
    private mutating func getFirstVisibleSet() {
        for i in 0..<displayedCards.count {
            for j in i+1..<displayedCards.count {
                for k in j+1..<displayedCards.count {
                    if isValidSet(displayedCards[i], displayedCards[j], displayedCards[k]) {
                        firstVisibleSet = (displayedCards[i], displayedCards[j], displayedCards[k])
                        return
                    }
                }
            }
        }
        firstVisibleSet = nil
    }
    
    // Representation of a card from Set
    struct Card: Identifiable, CustomStringConvertible, Equatable {
        let color: SetColor
        let symbol: Symbol
        let shading: Shading
        let number: Int
        
        var id: String
        var description: String {
            "\(number) \(color) \(shading) \(symbol)"
        }
    }
    
    enum Symbol: String, CaseIterable{
        case diamond, oval, squiggle
    }
    
    enum Shading: String, CaseIterable {
        case filled, outlined, striped
    }
    
    enum SetColor: String, CaseIterable {
        case green, purple, red
    }
}
