//
//  NavigationManager.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-04-03.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func openLink(_ link: String) {
        if let destination = LinkHandler.shared.handle(link: link) {
            path.append(destination)
        }
    }
    
    func openLink(_ url: URL) {
        if let destination = LinkHandler.shared.handle(url: url) {
            path.append(destination)
        }
    }
}
