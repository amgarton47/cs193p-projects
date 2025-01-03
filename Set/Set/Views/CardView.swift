//
//  CardView.swift
//  Set
//
//  Created by Aidan Garton on 12/27/24.
//

import SwiftUI

struct CardView: View {
    typealias Card = SetGame.Card
    
    let card: Card
    let selectedCards: [Card]
    var isMatch: Bool
    let displayedCards: [Card]
    let dealtCards: [Card]
    let discardedCards: [Card]
    
    var body: some View {
        if displayedCards.contains(card) {
            let isSelected = selectedCards.contains(card)
            var borderColor: Color {
                if isSelected {
                    if isMatch {
                        return Color.green
                    } else if selectedCards.count == 3 {
                        return Color.red
                    } else {
                        return Color.blue
                    }
                } else {
                    return Color.black
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(.white)
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .strokeBorder(borderColor, lineWidth: isSelected ? Constants.selectedBorderWidth : Constants.borderWidth)
                CardContentView(card: card)
                    .padding(Constants.cardPadding)
            }
            .rotationEffect(isMatch && selectedCards.contains(card) ? .degrees(180) : .degrees(0))
            .blur(radius: !isMatch && selectedCards.contains(card) && selectedCards.count == 3 ? 1 : 0)
        } else if discardedCards.contains(card) {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(.white)
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .strokeBorder(.black, lineWidth: Constants.borderWidth)
                CardContentView(card: card)
                    .padding(Constants.cardPadding)
            }
        } else if !dealtCards.contains(card) {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
        } else {
            Text("WTF")
        }
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12.0
        static let selectedBorderWidth: CGFloat = 4.0
        static let borderWidth: CGFloat = 2.0
        static let cardPadding: CGFloat = 10.0
    }
}

#Preview {
    let card = SetGame.Card(color: .green, symbol: .squiggle, shading: .striped, number: 2, id: "testCard")
    CardView(card: card, selectedCards: [card], isMatch: false, displayedCards: [card], dealtCards: [], discardedCards: [])
    CardView(card: card, selectedCards: [card], isMatch: false, displayedCards: [], dealtCards: [card], discardedCards: [card])
}
