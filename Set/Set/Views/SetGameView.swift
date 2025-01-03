//
//  ContentView.swift
//  Set
//
//  Created by Aidan Garton on 12/19/24.
//

import SwiftUI

struct SetGameView: View {
    typealias Card = SetGame.Card
    @ObservedObject var viewModel: SetGameViewModel
    
    init(viewModel: SetGameViewModel) {
        self.viewModel = viewModel
        self.dealtCards = []
        self.discardedCards = []
    }
    
    var body: some View {
        ZStack {
            VStack {
                header
                cards
                cardPiles
                footer
            }
            .padding(.horizontal, Constants.inset)
        }
    }
    
    private var cardPiles: some View {
        HStack {
            deck
            discard
        }
    }
    
    @Namespace private var dealingNameSpace
    
    private var deck: some View {
            ZStack {
                ForEach(viewModel.deck) { card in
                    CardView(card: card, selectedCards: viewModel.selectedCards, isMatch: false, displayedCards: viewModel.cards, dealtCards: dealtCards, discardedCards: discardedCards)
                        .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                }
                .frame(width: 65, height: 65 / Constants.Card.aspectRatio)
                .onTapGesture {
                    withAnimation (.easeInOut(duration: 1)) {
                        if viewModel.isMatch {
                            discardedCards.append(contentsOf: viewModel.selectedCards)
                        }
                        viewModel.deal3Cards()
                        dealtCards = viewModel.cards
                    }
                }
            }
    }
    
    @State private var dealtCards: [Card]
    @State private var discardedCards: [Card]
    
    @Namespace private var discardNameSpace
    
    private var discard: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(lineWidth: 2.0)
                ForEach(discardedCards) { card in
                    CardView(card: card, selectedCards: viewModel.selectedCards, isMatch: false, displayedCards: viewModel.cards, dealtCards: dealtCards, discardedCards: discardedCards)
                        .matchedGeometryEffect(id: card.id, in: discardNameSpace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                }
            }
            .frame(width: 65, height: 65 / Constants.Card.aspectRatio)
        }
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
            Button("New Game") {
                withAnimation (.easeInOut(duration: 1)) {
                    viewModel.newGame()
                    dealtCards = viewModel.cards
                    discardedCards = []
                }
            }
            Spacer()
//            Button("Hint") {
//                withAnimation {
//                    viewModel.getHint()
//                }
//            }
//            Spacer()
            Button("Shuffle") {
                withAnimation {
                    dealtCards = dealtCards.shuffled()
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var cards: some View {
        AspectVGrid(dealtCards, aspectRatio: Constants.Card.aspectRatio) { card in
            CardView(card: card, selectedCards: viewModel.selectedCards, isMatch: viewModel.isMatch, displayedCards: viewModel.cards, dealtCards: dealtCards, discardedCards: discardedCards)
                .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                .matchedGeometryEffect(id: card.id, in: discardNameSpace)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                .onTapGesture {
                    withAnimation {
                        if viewModel.isMatch {
                            discardedCards.append(contentsOf: viewModel.selectedCards)
                            dealtCards = dealtCards.filter { !viewModel.selectedCards.contains($0) }
                        }
                        
                        viewModel.choose(card)
                    }
                }
                .padding(Constants.Card.padding)
        }
        .onAppear {
            withAnimation {
                for card in viewModel.cards {
                    dealtCards.append(card)
                }
            }
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
