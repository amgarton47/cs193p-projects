//
//  ContentView.swift
//  Set
//
//  Created by Aidan Garton on 12/19/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: SetGameModelView
    
    var body: some View {
        VStack (spacing: 5) {
            header
            cards
            footer
        }
        .padding(.horizontal, 20.0)
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
        AspectVGrid(viewModel.cards, aspectRatio: 63/80) { card in
            CardView(card: card, viewModel: viewModel)
                .background(.white)
                .onTapGesture { viewModel.choose(card) }
                .padding(5.0)
        }
    }
}

private struct CardView: View {
    let card: SetGame.Card
    @ObservedObject var viewModel: SetGameModelView
    
    var body: some View {
        let isSelected = viewModel.selectedCards.contains(card)
        let cardContentPadding = 10.0
        var borderColor: Color {
            if isSelected {
                if viewModel.isMatch {
                    return Color.green
                } else if viewModel.selectedCards.count == 3 {
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
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(borderColor, lineWidth: isSelected ? 4 : 2)
        }
    }
}

private struct CardContentView: View {
    let card: SetGame.Card
    var body: some View {
        let spacingBetweenShapes: CGFloat = 10.0
        let aspectRatio: CGFloat = 2/1
        
        GeometryReader { geometry in
            let shapeHeight = min(
                                (geometry.size.height - 2 * spacingBetweenShapes) / 3,
                                geometry.size.width / aspectRatio)
            let shapeWidth = shapeHeight * aspectRatio
            VStack (spacing: spacingBetweenShapes) {
                ForEach(0..<card.number, id: \.self) { _ in
                    getSymbolView()
                        .frame(width: shapeWidth, height: shapeHeight)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    func getShadedSymbol(_ shape: some Shape) -> some View {
        switch card.shading{
        case .filled:
            shape.fill()
        case .outlined:
            shape.stroke(lineWidth: 4)
        case .striped:
            ZStack {
                Stripes()
                    .stroke(lineWidth: 2)
                    .clipShape(shape)
                shape.stroke(lineWidth: 4)
            }
        }
    }
    
    @ViewBuilder
    func getColoredSymbol(_ shape: some View) -> some View {
        var cardColor: Color {
            switch card.color {
            case .red:
                Color(red: 220 / 255, green: 59 / 255, blue: 64 / 255)
            case .green:
                Color(red: 0.0, green: 159 / 255, blue: 96 / 255)
            case .purple:
                Color(red: 124 / 255, green: 53 / 255, blue: 129 / 255)
            }
        }
        shape.foregroundColor(cardColor)
    }
    
    func getStyledView(_ shape: some Shape) -> some View {
        getColoredSymbol(getShadedSymbol(shape))
    }
    
    @ViewBuilder
    func getSymbolView() -> some View {
        switch card.symbol {
        case .diamond:
            getStyledView(Diamond())
        case .squiggle:
            getStyledView(Squiggle())
        case .oval:
            getStyledView(RoundedRectangle(cornerRadius: 33))
        }
    }
}

private struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startPoint = CGPoint(x: rect.midX, y: rect.minY)
        
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: startPoint)
        
        return path
    }
}

private struct Stripes: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        for x in stride(from: 0, through: width, by: width / 9) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: height))
        }
        return path
    }
}

private struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
            var path = Path()
                    
            path.move(to: CGPoint(x: 104.0, y: 15.0))
            path.addCurve(to: CGPoint(x: 63.0, y: 54.0),
                          control1: CGPoint(x: 112.4, y: 36.9),
                          control2: CGPoint(x: 89.7, y: 60.8))
            path.addCurve(to: CGPoint(x: 27.0, y: 53.0),
                          control1: CGPoint(x: 52.3, y: 51.3),
                          control2: CGPoint(x: 42.2, y: 42.0))
            path.addCurve(to: CGPoint(x: 5.0, y: 40.0),
                          control1: CGPoint(x: 9.6, y: 65.6),
                          control2: CGPoint(x: 5.4, y: 58.3))
            path.addCurve(to: CGPoint(x: 36.0, y: 12.0),
                          control1: CGPoint(x: 4.6, y: 22.0),
                          control2: CGPoint(x: 19.1, y: 9.7))
            path.addCurve(to: CGPoint(x: 89.0, y: 14.0),
                          control1: CGPoint(x: 59.2, y: 15.2),
                          control2: CGPoint(x: 61.9, y: 31.5))
            path.addCurve(to: CGPoint(x: 104.0, y: 15.0),
                          control1: CGPoint(x: 95.3, y: 10.0),
                          control2: CGPoint(x: 100.9, y: 6.9))
            
            let pathRect = path.boundingRect
            path = path.offsetBy(dx: rect.minX - pathRect.minX, dy: rect.minY - pathRect.minY)
            
            let scale: CGFloat = rect.width / pathRect.width
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            path = path.applying(transform)
            
            
            return path
                .offsetBy(dx: rect.minX - path.boundingRect.minX, dy: rect.midY - path.boundingRect.midY)
        }
}

#Preview {
    ContentView(viewModel: SetGameModelView())
}
