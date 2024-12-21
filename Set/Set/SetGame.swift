//
//  SetGame.swift
//  Set
//
//  Created by Aidan Garton on 12/19/24.
//

import Foundation

struct SetGame {
    private(set) var deck: [Card] = []
    private(set) var displayedCards: [Card] = []
    private(set) var selectedCards: [Card] = []
    private(set) var isMatch = false
    
    init() {
        generateDeck()
        deck = deck.shuffled()
        displayedCards.append(contentsOf: deck[0..<12])
        deck.removeFirst(12)
    }
    
    mutating func deal3Cards() {
        if isMatch && selectedCards.count == 3 {
            displayedCards.removeAll(where: {selectedCards.contains($0)})
            selectedCards.removeAll()
            isMatch = false
        }
        
        displayedCards.append(contentsOf: deck[0..<3])
        deck.removeFirst(3)
    }

    
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
    
    private func isValidSet(_ c1: Card, _ c2: Card, _ c3: Card) -> Bool {
        func propIsAllSameOrAllDifferent<T: Equatable>(_ a: T, _ b: T, _ c: T) -> Bool {
            return (a == b && b == c) || (a != b && b != c && a != c)
        }
        
        return propIsAllSameOrAllDifferent(c1.color, c2.color, c3.color) &&
        propIsAllSameOrAllDifferent(c1.number, c2.number, c3.number) &&
        propIsAllSameOrAllDifferent(c1.shading, c2.shading, c3.shading) &&
        propIsAllSameOrAllDifferent(c1.symbol, c2.symbol, c3.symbol)
    }
    
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
                displayedCards.removeAll(where: {selectedCards.contains($0)})
                selectedCards.removeAll()
                isMatch = false
            } else {
                selectedCards.removeAll()
                selectedCards.append(card)
            }
        }
    }
    
    struct Card: Identifiable, CustomStringConvertible, Equatable {
        let color: SetColor
        let symbol: Symbol
        let shading: Shading
        let number: Int
        var isPartOfSet = false
        
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
