//
//  OnboardingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2026-01-01.
//

import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var currentIndex = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Reddit, your way",
            subtitle: "Filters, themes, and browsing all in your hands.",
            image: "bolt.fill"
        ),
        OnboardingPage(
            title: "Post anything",
            subtitle: "Text, images, videos, GIFs, galleries, links, and polls exactly as you want.",
            image: "sparkles"
        ),
        OnboardingPage(
            title: "Anonymous ≠ Limited",
            subtitle: "Save, vote, and revisit, even when logged out.",
            image: "eye.slash.fill"
        )
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .padding(16)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            PageIndicator(
                count: pages.count,
                currentIndex: currentIndex
            )
            
            Button(action: advance) {
                Text(currentIndex == pages.count - 1 ? "Get Started" : "Next")
                    .frame(maxWidth: .infinity)
            }
            .filledButton()
            .padding(16)
        }
        .animation(.default, value: currentIndex)
    }
    
    private func advance() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
        } else {
            onFinish()
        }
    }
    
    struct OnboardingPage: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let image: String
    }
    
    struct OnboardingPageView: View {
        let page: OnboardingPage

        var body: some View {
            VStack(spacing: 24) {
                SwiftUI.Image(systemName: page.image)
                    .font(.system(size: 56))

                Text(page.title)
                    .font(.largeTitle.bold())

                Text(page.subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
    
    struct PageIndicator: View {
        let count: Int
        let currentIndex: Int

        var body: some View {
            HStack(spacing: 8) {
                ForEach(0..<count, id: \.self) { index in
                    Capsule()
                        .fill(index == currentIndex ? .black : .gray)
                        .frame(width: index == currentIndex ? 18 : 6, height: 6)
                        .animation(.easeInOut, value: currentIndex)
                }
            }
            .padding(.bottom, 12)
        }
    }
}
