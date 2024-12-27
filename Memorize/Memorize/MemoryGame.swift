//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Aidan Garton on 12/16/24.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable & Hashable {
    private(set) var cards: Array<Card>
    private(set) var score: Int
    private(set) var seenCards: Set<String>
    private(set) var time: Date
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        score = 0
        seenCards = []
        time = Date()
        
        // add numberOfPairsOfCards x 2
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    var indexOfOnlyFaceUpCard : Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = newValue == $0 } }
    }
    
    
    mutating func choose(_ card: Card){
        if let idx = cards.firstIndex(where: {$0.id == card.id}) {
            
            if !cards[idx].isFaceUp && !cards[idx].isMatched{
                if let potentialMatchIndex = indexOfOnlyFaceUpCard {
                    if cards[idx].content == cards[potentialMatchIndex].content {
                        cards[idx].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
                    } else {
                        if (seenCards.contains(cards[potentialMatchIndex].id) || seenCards.contains(cards[idx].id)){
                            score -= 1
                        }
                        
                        seenCards.insert(cards[idx].id)
                        seenCards.insert(cards[potentialMatchIndex].id)
                    }
                }else {
                    indexOfOnlyFaceUpCard = idx
                }
                cards[idx].isFaceUp = true
            }
        }
    }
    
    struct Card: Equatable, Identifiable, CustomStringConvertible {
        let content: CardContent
        var isFaceUp = false
        var isMatched = false
        
        var id: String
        var description: String {
            "\(id): \(content) \(isMatched ? "matched" : "")"
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
