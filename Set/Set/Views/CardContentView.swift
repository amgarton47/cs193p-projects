//
//  CardContentView.swift
//  Set
//
//  Created by Aidan Garton on 12/27/24.
//

import SwiftUI

struct CardContentView: View {
    let card: SetGame.Card
    var body: some View {
        GeometryReader { geometry in
            let shapeHeight = min(
                                (geometry.size.height - 2 * Constants.spacingBetweenSymbols) / 3,
                                geometry.size.width / Constants.symbolAspectRatio)
            let shapeWidth = shapeHeight *  Constants.symbolAspectRatio
            VStack (spacing: Constants.spacingBetweenSymbols) {
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
            shape.stroke(lineWidth: Constants.symbolLineWidth)
        case .striped:
            ZStack {
                Stripes()
                    .stroke(lineWidth: Constants.stripesLineWidth)
                    .clipShape(shape)
                shape.stroke(lineWidth: Constants.symbolLineWidth)
            }
        }
    }
    
    @ViewBuilder
    func getColoredSymbol(_ shape: some View) -> some View {
        var cardColor: Color {
            switch card.color {
            case .red:
                Constants.Colors.red
            case .green:
                Constants.Colors.green
            case .purple:
                Constants.Colors.purple
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
            getStyledView(RoundedRectangle(cornerRadius: Constants.ovalSymbolCornerRadius))
        }
    }
    
    private struct Constants {
        static let spacingBetweenSymbols: CGFloat = 10.0
        static let symbolAspectRatio: CGFloat = 2/1
        
        struct Colors {
            static let red: Color = Color(red: 220 / 255, green: 59 / 255, blue: 64 / 255)
            static let green: Color = Color(red: 0.0, green: 159 / 255, blue: 96 / 255)
            static let purple: Color = Color(red: 124 / 255, green: 53 / 255, blue: 129 / 255)
        }
        
        static let ovalSymbolCornerRadius: CGFloat = 33
        static let symbolLineWidth: CGFloat = 4
        static let stripesLineWidth: CGFloat = 2
    }
}
