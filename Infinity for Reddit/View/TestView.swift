//
//  TestView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        List(1...10, id: \.self) { index in
            Button(
                action: {
                    print("You've tapped me!")
                },
                label: {
                    Text("Do you dare interact?")
                }
            )
            .supportsLongPress {
                print("Looks like you've pressed me.")
            }
            .listPlainItemNoInsets()
        }
        .listStyle(.plain)
        .navigationTitle("Ripple Demo")
    }
}

struct SupportsLongPress: PrimitiveButtonStyle {
    
    let longPressAction: () -> ()
    
    @State var isPressed: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Rectangle()
                    .fill(.green)
                    .opacity(isPressed ? 1 : 0)
            )
            .onTapGesture {
                configuration.trigger()
            }
            .onLongPressGesture(
                perform: {
                    self.longPressAction()
                },
                
                onPressingChanged: { pressing in
                    self.isPressed = pressing
                }
            )
    }
}

struct SupportsLongPressModifier: ViewModifier {
    let longPressAction: () -> ()
    
    func body(content: Content) -> some View {
        content.buttonStyle(SupportsLongPress(longPressAction: self.longPressAction))
    }
}

extension View {
    func supportsLongPress(longPressAction: @escaping () -> ()) -> some View {
        modifier(SupportsLongPressModifier(longPressAction: longPressAction))
    }
}

struct MyCustomButtonRoom: View {
    
    var body: some View {
        
        Button(
            action: {
                print("You've tapped me!")
            },
            label: {
                Text("Do you dare interact?")
            }
        )
        .supportsLongPress {
            print("Looks like you've pressed me.")
        }
    }
}
