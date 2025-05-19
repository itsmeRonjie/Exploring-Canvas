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
    let radiusOfInfluence = 0.2
    let colors: [Color] = [
        .blue, .green, .red,
        .yellow, .orange, .purple,
        .pink, .gray, .cyan,
        .brown, .indigo, .mint
    ]
    
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
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            Text("Welcome to Canvas!")
                .font(.largeTitle)
                .foregroundStyle(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
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
        let radius = radiusOfInfluence * min(size.width, size.height)
        for dot in dots {
            let actualX = dot.x * size.width
            let actualY = dot.y * size.height
            
            let distance = distance(
                x0: actualX,
                y0: actualY,
                x1: dragLocation.x,
                y1: dragLocation.y
            )
            var dim = dotRadius * 2
            
            var color: GraphicsContext.Shading = .color(.blue)
            
            if distance > radius {
                let factor = radius / distance
                dim *= factor * factor
            }
            
            if distance > 1.2 * radius {
                color = .color(.green.opacity(0.7))
            }
            
            
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
                with: color
            )
            
            drawNoisyLines(
                context: context,
                x0: dragLocation.x,
                y0: dragLocation.y,
                x1: actualX,
                y1: actualY,
                radius: radius
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
        let dist = distance(
            x0: x0,
            y0: y0,
            x1: x1,
            y1: y1
        )
        
        if dist <= radius {
            var path = Path()
            
            path.move(to: CGPoint(x: x0, y: y0))
            
            let segments = 50
            
            for i in 1...segments {
                let t = CGFloat(i) / CGFloat(segments)
                let x = lerp(a: x0, b: x1, t: t)
                let y = lerp(a: y0, b: y1, t: t)
                
                let k = noise(
                    x: x / 5 + x0,
                    y: y / 5 + y0
                ) * 30
                
                let angle = noise(
                    x: x + k,
                    y: y + k
                )
                
                let dist = sin(angle) * 0.5
                path.addLine(
                    to: CGPoint(
                        x: x + k + dist,
                        y: y + k + dist
                    )
                )
            }
            
            let randomColor: Color = colors.randomElement() ?? .white
            
            context
                .stroke(path, with: .color(randomColor.opacity(0.7)))
        }
    }
    
    func distance(
        x0: CGFloat,
        y0: CGFloat,
        x1: CGFloat,
        y1: CGFloat
    ) -> CGFloat {
        let dx = x1 - x0
        let dy = y1 - y0
        
        return sqrt(dx * dx + dy * dy)
    }
    
    func lerp(
        a: CGFloat,
        b: CGFloat,
        t: CGFloat
    ) -> CGFloat {
        a + (b - a) * t
    }
    
    func noise(
        x: CGFloat,
        y: CGFloat,
        t: CGFloat = 101
    ) -> CGFloat {
        let w0 = 0.1 * sin(0.3 * x + 1.4 * t + 2.0 + 2.5 * sin(0.4 * y - 1.3 * t + 1.0))
        let w1 = 0.1 * sin(0.2 * y + 1.5 * t + 2.8 + 2.3 * sin(0.5 * x - 1.2 * t + 0.5))
        return w0 + w1
    }
}

#Preview {
    MainView()
}
