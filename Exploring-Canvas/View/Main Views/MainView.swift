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
    let dragDotRadius = 5.0
    let radiusOfInfluence = 0.3
    
    @State private var dragLocation: CGPoint = CGPoint(
        x: CGFloat.random(in: 100...200),
        y: CGFloat.random(in: 100...200)
    )
    
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
                let circleRect = CGRect(
                    x: dragLocation.x - dragDotRadius,
                    y: dragLocation.y - dragDotRadius,
                    width: dragDotRadius * 2,
                    height: dragDotRadius * 2
                )
                
                let dragDot = Path(ellipseIn: circleRect)
                
                drawDotsAndLines(
                    context: context,
                    size: size,
                    dots: dots,
                    dotRadius: dotRadius,
                    dragLocation: dragLocation,
                    radiusOfInfluence: radiusOfInfluence
                )
                
                context.fill(
                    dragDot,
                    with: .color(.red)
                )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        dragLocation = value.location
                    }
            )
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
            
            drawNoisyLines(
                context: context,
                x0: dragLocation.x,
                y0: dragLocation.y,
                x1: actualX,
                y1: actualY,
                radius: radiusOfInfluence
            )
        }
    }
    
    func drawNoisyLines(
        context: GraphicsContext,
        x0: CGFloat,
        y0: CGFloat,
        x1: CGFloat,
        y1: CGFloat,
        radius: CGFloat
    ) {
        var path = Path()
        
        path.move(to: CGPoint(x: x0, y: y0))
        path.addLine(to: CGPoint(x: x1, y: y1))
        
        context
            .stroke(path, with: .color(.white.opacity(0.7)))
    
    }
}

#Preview {
    MainView()
}
