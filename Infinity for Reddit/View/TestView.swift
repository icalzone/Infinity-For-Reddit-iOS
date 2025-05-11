//
//  TestView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject private var namespaceManager: NamespaceManager
    
    @State private var flip: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("fuck you")
                    .applyIf(!flip) {
                        $0.matchedGeometryEffect(id: "test", in: namespaceManager.animation)
                    }
            }
            
            if flip {
                TestViewFullScreen()
            }
        }
        .onTapGesture {
//            withAnimation(.smooth(duration: 5)) {
//                flip.toggle()
//            }
            
//            GalleryFullScreenView(items: nil, mediaMetadata: nil, galleryScrollState: <#GalleryScrollState#>) {
//                                    
//                                }
//                                .id(UUID())
        }
    }
}

struct TestViewFullScreen: View {
    @EnvironmentObject private var namespaceManager: NamespaceManager
    
    @State private var flip: Bool = false
    
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            
            Text("fuck you")
                .matchedGeometryEffect(id: "test", in: namespaceManager.animation)
        }
    }
}
