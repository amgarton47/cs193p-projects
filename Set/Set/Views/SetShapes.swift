//
//  Shapes.swift
//  Set
//
//  Created by Aidan Garton on 12/27/24.
//

import SwiftUI

struct Diamond: Shape {
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
