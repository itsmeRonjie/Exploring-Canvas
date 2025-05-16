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
    let circleRadius = 75.0
    
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
                    x: center.x - circleRadius,
                    y: center.y - circleRadius,
                    width: circleRadius * 2,
                    height: circleRadius * 2
                )
                
                context.fill(
                    Path(ellipseIn: circleRect),
                    with: .color(.blue)
                )
            }
        }
    }
}

#Preview {
    MainView()
}
