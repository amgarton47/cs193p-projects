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
        VStack {
            Text("Sets found: \(viewModel.setsFound)")
            ScrollView {
                cards
            }
            
            HStack {
                Button("Deal 3 More Cards") { viewModel.deal3Cards() }
                    .disabled(viewModel.deck.count < 3)
                Spacer()
                Button("New Game") { viewModel.newGame() }
            }.padding()
            
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 75), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                CardView(card, viewModel: viewModel)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture { viewModel.choose(card) }
            }
        }
    }
}

struct CardView: View {
    @ObservedObject var viewModel: SetGameModelView
    let card: SetGame.Card
    var color: Color
    
    init(_ card: SetGame.Card, viewModel: SetGameModelView) {
        self.card = card
        self.viewModel = viewModel
        
        switch card.color {
        case .red:
            color = Color(red: 220 / 255, green: 59 / 255, blue: 64 / 255)
        case .green:
            color = Color(red: 0.0, green: 159 / 255, blue: 96 / 255)
        case .purple:
            color = Color(red: 124 / 255, green: 53 / 255, blue: 129 / 255)
        }
    }
    
    var body: some View {
        let isSelected = viewModel.selectedCards.contains(card)
        let isASet = viewModel.isMatch && isSelected
        let isNotASet = !viewModel.isMatch && isSelected && viewModel.selectedCards.count == 3
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isASet ? .green : .white)
                .fill(isNotASet ? .red : .white)
                .strokeBorder(lineWidth: 2)
                .foregroundColor(isSelected ? .yellow : .black)
                .opacity(isASet || isNotASet ? 0.2 : 1)
            
            switch card.symbol {
                case .diamond:
                    VStack {
                        ForEach(0..<card.number, id: \.self) { _ in
                            if card.shading == .striped {
                                ZStack {
                                    Stripes()
                                        .stroke(lineWidth: 2)
                                        .clipShape(Diamond())
                                    Diamond().stroke(lineWidth: 4)
                                }
                            } else if card.shading == .filled {
                                Diamond()
                            } else if card.shading == .outlined {
                                Diamond().stroke(lineWidth: 4)
                            }
                        }
                        .frame(width: 60.0, height: 30.0)
                    }
                    .foregroundColor(color)
                case .squiggle:
                    VStack {
                        ForEach(0..<card.number, id: \.self) { _ in
                            if card.shading == .striped {
                                ZStack {
                                    Stripes()
                                        .stroke(lineWidth: 2)
                                        .clipShape(Squiggle())
                                    Squiggle().stroke(lineWidth: 4)
                                }
                            } else if card.shading == .filled {
                                Squiggle()
                            } else if card.shading == .outlined {
                                Squiggle().stroke(lineWidth: 4)
                            }
                        }
                        .frame(width: 60.0, height: 30.0)
                    }
                    .foregroundColor(color)
                case .oval:
                    VStack {
                        ForEach(0..<card.number, id: \.self) { _ in
                            if card.shading == .striped {
                                ZStack {
                                    Stripes()
                                        .stroke(lineWidth: 2)
                                        .clipShape(Ellipse())
                                    Ellipse().stroke(lineWidth: 4)
                                }
                            } else if card.shading == .filled {
                                Ellipse()
                            } else if card.shading == .outlined {
                                Ellipse().stroke(lineWidth: 4)
                            }
                        }
                        .frame(width: 60.0, height: 30.0)
                    }
                    .foregroundColor(color)
            }
        }.scaleEffect(isSelected ? 0.95 : 1).animation(.easeIn(duration: 0.05), value: isSelected)
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

        path.move(to: CGPoint(x: center.x, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: 0))

        return path
      }
}

struct Stripes: Shape {
    
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

struct Squiggle: Shape {
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
