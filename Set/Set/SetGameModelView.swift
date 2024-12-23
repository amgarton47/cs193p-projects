//
//  SetGameModelView.swift
//  Set
//
//  Created by Aidan Garton on 12/19/24.
//

import SwiftUI

class SetGameModelView: ObservableObject {
    @Published private var setGame: SetGame
    
    init() {
        setGame = SetGame()
    }

    var cards: [SetGame.Card] {
        setGame.displayedCards
    }
    
    var deck: [SetGame.Card] {
        setGame.deck
    }
    
    var selectedCards: [SetGame.Card] {
        setGame.selectedCards
    }
    
    var isMatch: Bool {
        setGame.isMatch
    }
    
    var setsFound: Int {
        27 - (deck.count + cards.count) / 3
    }
    
    // MARK: - Intents
    func choose(_ card: SetGame.Card){
        setGame.choose(card)
    }
    
    func deal3Cards() {
        setGame.deal3Cards()
    }
    
    func newGame(){
        setGame = SetGame()
    }
    
    func getHint() {
        setGame.getHint()
    }
}
