//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Aidan Garton on 12/16/24.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String>{
        let consideredEmojis = theme.emojis.shuffled()
        let numPairs = min(theme.numPairs, consideredEmojis.count)
        return MemoryGame(numberOfPairsOfCards: numPairs) { pairIndex in
            if consideredEmojis.indices.contains(pairIndex) {
                return consideredEmojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }

    @Published private var model: MemoryGame<String>
    private(set) var theme: Theme
    
    init() {
        theme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        model.shuffle()
    }
    
    var cards: Array<Card> {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var time: Date {
        model.time
    }
    
    // MARK: - Intents
    func shuffle(){
        model.shuffle()
        objectWillChange.send()
    }
    
    func choose(_ card: Card){
        model.choose(card)
    }
    
    func newGame(){
        theme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        model.shuffle()
    }
    
    
    // Themes
    private let themes: [Theme] = [
        Theme(name: "Halloween", color: .orange,  emojis: ["👻", "🎃", "🧙‍♀️", "💀", "🍭", "🕸️"], numPairs: 12),
        Theme(name: "Xmas",      color: .green,   emojis: ["🎅", "🎄", "🤶", "☃️", "⛸️", "🌨️", "⛷️", "🎁"], numPairs: 5),
        Theme(name: "Fantasy",   color: .purple,  emojis: ["🧚", "🐉", "🧌", "🧝🏼‍♀️", "🧝‍♂️", "🧙‍♂️", "🧜‍♀️", "🧞‍♂️", "🏰"], numPairs: 2),
        Theme(name: "Ally💕",    color: .pink,    emojis: ["🐣", "🍙", "🇯🇵", "🤸🏼‍♀️", "👩🏽‍❤️‍💋‍👨🏻", "🥰"], numPairs: 4),
        Theme(name: "Summer",    color: .blue,    emojis: ["☀️", "⛱️", "🌊", "🥵", "🏖️", "🏊", "🏃‍♂️", "🍦", "⛵️"], numPairs: 9),
//        Theme(name: "Food",      color: .brown,   emojis: ["🍔", "🌭", "🌮", "🍕", "🍣", "🍝", "🍎", "🥞", "🍳", "🍤", "🥟", "🍔", "🌭", "🌮", "🍕", "🍣", "🍝", "🍎", "🥞", "🍳", "🍤", "🥟"], numPairs: 24)
    ]
    
    struct Theme {
        let name: String
        let color: Color
        let emojis: [String]
        let numPairs: Int
    }
}
