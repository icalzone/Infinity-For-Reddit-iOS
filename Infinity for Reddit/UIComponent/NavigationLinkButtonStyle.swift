//
//  NavigationLinkButtonStyle.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-21.
//

import SwiftUI

struct NavigationLinkButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .background(configuration.isPressed ? Color.gray : Color.clear)
            .listRowBackground(configuration.isPressed ? Color.gray : Color.clear)
    }
}
