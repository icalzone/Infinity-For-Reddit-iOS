//
//  CustomAlert.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-19.
//

import SwiftUI

struct CustomAlert<Content: View>: View {
    @EnvironmentObject private var customThemeViewModel: CustomThemeViewModel
    @Binding var isPresented: Bool
    
    var title: String
    var subtitle: String?
    var content: Content?
    var onDismiss: (() -> Void)?
    var onConfirm: (() -> Void)?
    
    init(
        title: String,
        subtitle: String? = nil,
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content? = { nil },
        onDismiss: (() -> Void)? = nil,
        onConfirm: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self._isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onDismiss?()
                        isPresented = false
                    }
                
                VStack(spacing: 0) {
                    Text(title)
                        .primaryText()
                    
                    if let subtitle {
                        Spacer()
                            .frame(height: 16)
                        
                        Text(subtitle)
                            .secondaryText()
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    if let content {
                        content
                        
                        Spacer()
                            .frame(height: 16)
                    }
                    
                    HStack(spacing: 0) {
                        Button {
                            onDismiss?()
                            isPresented = false
                        } label: {
                            Text("Cancel")
                                .neutralTextButton()
                        }
                        
                        Button {
                            onConfirm?()
                            isPresented = false
                        } label: {
                            Text("OK")
                                .positiveTextButton()
                        }
                    }
                }
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: customThemeViewModel.currentCustomTheme.cardViewBackgroundColor))
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: -1)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                }
            }
        }
    }
}
