//
//  CardView.swift
//  Memorize
//
//  Created by Aidan Garton on 12/26/24.
//

import SwiftUI

struct CardView: View {
    typealias Card = MemoryGame<String>.Card
    var card: Card
    
    var body: some View {
        Pie(endAngle: Angle.degrees(240))
            .opacity(Constants.Pie.opacity)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .aspectRatio(1, contentMode: .fit)
                    .multilineTextAlignment(.center)
                    .padding(Constants.Pie.inset)
            )
            .cardify(isFaceUp: card.isFaceUp)
            .padding(Constants.inset)
            .opacity(card.isMatched ? 0 : 1)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 5
        
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 5
        }
    }
}


struct CardView_Previews: PreviewProvider {
    typealias Card = MemoryGame<String>.Card
    
    static var previews: some View {
        VStack {
            HStack {
                CardView(card: Card(content: "X", isFaceUp: true, id: "test1"))
                CardView(card: Card(content: "X", isFaceUp: false, id: "test2"))
            }
            HStack {
                CardView(card: Card(content: "This is a very long string does it fit or not?", isFaceUp: true, isMatched: false, id: "test3"))
                CardView(card: Card(content: "X", isFaceUp: false, isMatched: true, id: "test4"))
            }
        }
        .padding()
        .foregroundStyle(.blue)
    }
}
