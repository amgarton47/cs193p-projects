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
            header
            cards
                .foregroundColor(viewModel.theme.color)
                .animation(.default, value: viewModel.cards)
           footer
        }
        .padding()
    }
    
    @ViewBuilder
    private var header: some View {
        Group {
            Text("Memory Game: \(viewModel.theme.name)")
            Text("Score: \(viewModel.score)")
        }
        .font(.title)
        .foregroundColor(viewModel.theme.color)
    }
    
    @ViewBuilder
    private var footer: some View {
        Button("New Game") {
            viewModel.newGame()
        }
        Text(viewModel.time, style: .timer)
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: 2/3) { card in
            CardView(card: card)
                .padding(4)
                .onTapGesture { viewModel.choose(card) }
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

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
