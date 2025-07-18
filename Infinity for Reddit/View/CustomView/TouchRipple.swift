//
//  TouchRipple.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-17.
//

import SwiftUI

struct TouchRipple<Content: View, BackgroundShape: Shape>: View {
    let backgroundShape: BackgroundShape
    var action: (() -> Void)? = nil
    let content: () -> Content

    @State private var validTouch: Bool = true
    @State private var isPressed = false
    @State private var dragStartLocation: CGPoint? = nil
    
    let maxTapMovement: CGFloat = 10
    
    init(backgroundShape: BackgroundShape = Rectangle(), action: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.backgroundShape = backgroundShape
        self.action = action
        self.content = content
    }

    var body: some View {
        content()
            .overlay(
                backgroundShape
                    .fill(Color.black.opacity(isPressed ? 0.05 : 0))
                    .animation(.easeInOut(duration: 0.15), value: isPressed)
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if dragStartLocation == nil {
                            dragStartLocation = value.startLocation
                        }
                        
                        guard let start = dragStartLocation else { return }
                        let distance = hypot(value.location.x - start.x, value.location.y - start.y)
                        
                        if distance <= maxTapMovement && validTouch {
                            if !isPressed {
                                isPressed = true
                            }
                        } else {
                            validTouch = false
                            if isPressed {
                                isPressed = false
                            }
                        }
                    }
                    .onEnded { value in
                        defer {
                            dragStartLocation = nil
                            isPressed = false
                            validTouch = true
                        }
                        
                        guard let start = dragStartLocation, validTouch else { return }
                        let dragDistance = hypot(value.location.x - start.x, value.location.y - start.y)
                        
                        if dragDistance <= maxTapMovement {
                            action?()
                        }
                    }
            )
    }
}
