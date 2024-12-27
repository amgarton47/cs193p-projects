//
//  ContentView.swift
//  Set
//
//  Created by Aidan Garton on 12/19/24.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        VStack {
            header
            cards
            footer
        }
        .padding(.horizontal, Constants.inset)
    }
    
    private var header: some View {
        VStack {
            Text("Set!")
                .font(.title)
            Text("Sets found: \(viewModel.setsFound)")
        }
    }
    
    private var footer: some View {
        HStack {
            Button("Deal 3 More Cards") { viewModel.deal3Cards() }
                .disabled(viewModel.deck.count < 3)
            Spacer()
            Button("New Game") { viewModel.newGame() }
            Spacer()
            Button("Hint") { viewModel.getHint() }
        }
        .padding()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: Constants.Card.aspectRatio) { card in
            CardView(card: card, selectedCards: viewModel.selectedCards, isMatch: viewModel.isMatch)
                .background(Color.white)
                .onTapGesture { viewModel.choose(card) }
                .padding(Constants.Card.padding)
        }
    }
    
    
    private struct Constants {
        struct Card {
            static let padding: CGFloat = 5
            static let aspectRatio: CGFloat = 63/80
        }
        static let inset: CGFloat = 20.0
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
