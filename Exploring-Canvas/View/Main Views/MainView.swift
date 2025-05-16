//
//  ContentView.swift
//  Exploring-Canvas
//
//  Created by Ronjie Diafante Man-on on 5/16/25.
//

import SwiftUI

struct MainView: View {
    let dots: [CGPoint]
    let n = 200
    let dotRadius = 2.5
    let radiusOfInfluence = 0.3
    
    @State private var dragLocation: CGPoint = .zero
    
    init() {
        self.dots = (0..<n).map { _ in
            CGPoint(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1)
            )
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            Canvas {
                context,
                size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let circleRect = CGRect(
                    x: center.x - dotRadius,
                    y: center.y - dotRadius,
                    width: dotRadius * 2,
                    height: dotRadius * 2
                )
                
                context.fill(
                    Path(ellipseIn: circleRect),
                    with: .color(.blue)
                )
                
                drawDotsAndLines(
                    context: context,
                    size: size,
                    dots: dots,
                    dotRadius: dotRadius,
                    dragLocation: dragLocation,
                    radiusOfInfluence: radiusOfInfluence
                )
            }
        }
    }
    
    func drawDotsAndLines(
        context: GraphicsContext,
        size: CGSize,
        dots: [CGPoint],
        dotRadius: CGFloat,
        dragLocation: CGPoint,
        radiusOfInfluence: CGFloat
    ) {
        for dot in dots {
            let actualX = dot.x * size.width
            let actualY = dot.y * size.height
            let dim = dotRadius * 2
            
            let circle = Path(
                ellipseIn: CGRect(
                    x: actualX - dotRadius,
                    y: actualY - dotRadius,
                    width: dim,
                    height: dim
                )
            )
            
            context.fill(
                circle,
                with: .color(.blue)
            )
        }
    }
}

#Preview {
    MainView()
}
