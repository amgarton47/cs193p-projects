//
//  CardView.swift
//  Set
//
//  Created by Aidan Garton on 12/27/24.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    var selectedCards: [SetGame.Card]
    var isMatch: Bool
    
    var body: some View {
        let isSelected = selectedCards.contains(card)
        let cardContentPadding = Constants.cardPadding
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
            CardContentView(card: card)
                .padding(cardContentPadding)
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .strokeBorder(borderColor, lineWidth: isSelected ? Constants.selectedBorderWidth : Constants.borderWidth)
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
    CardView(card: card, selectedCards: [card], isMatch: false)
}
