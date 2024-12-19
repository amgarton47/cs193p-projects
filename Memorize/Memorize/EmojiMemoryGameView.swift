//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Aidan Garton on 12/10/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Memory Game: \(viewModel.theme.name)")
                .font(.title)
                .foregroundColor(viewModel.theme.color)
            Text("Score: \(viewModel.score)")
                .font(.title)
                .foregroundColor(viewModel.theme.color)
            ScrollView{
                cards
                    .animation(.default, value: viewModel.cards)
            }
            Button("New Game") {
                viewModel.newGame()
            }
            Text(viewModel.time, style: .timer)
        }
        .padding()
    }
    var cards: some View {
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards){ card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture { viewModel.choose(card) }
            }
        }
        .foregroundColor(viewModel.theme.color)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isMatched ? 0 : 1)
    }
}


#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
