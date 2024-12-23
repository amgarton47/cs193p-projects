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
            cards
                .animation(.default, value: viewModel.cards)
            Button("New Game") {
                viewModel.newGame()
            }
            Text(viewModel.time, style: .timer)
        }
        .padding()
    }
    
    @ViewBuilder
    private var cards: some View {
        let aspectRatio: CGFloat = 2/3
        GeometryReader { geometry in
            let gridItemWidth = gridItemWidthThatFits(count: viewModel.cards.count, size: geometry.size, atAspectRatio: aspectRatio)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemWidth), spacing: 0)], spacing: 0) {
                ForEach(viewModel.cards){ card in
                    CardView(card)
                        .aspectRatio(aspectRatio , contentMode: .fit)
                        .padding(4)
                        .onTapGesture { viewModel.choose(card) }
                }
            }
            .foregroundColor(viewModel.theme.color)
        }
    }
    
    private func gridItemWidthThatFits(count: Int, size: CGSize, atAspectRatio aspectRatio: CGFloat) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return width.rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
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
