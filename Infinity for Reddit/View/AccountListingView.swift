//
//  AccountListingView.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-01-21.
//
import SwiftUI
import Swinject
import GRDB

import SwiftUI

struct AccountListingView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    SwiftUI.Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                    
                    Text("jason")
                        .font(.headline)
                    
                    Spacer()
                    
                    SwiftUI.Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 8)
                
                Rectangle() // Use a thin rectangle for the divider
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .padding(.horizontal, -7)
                
                HStack {
                    SwiftUI.Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                    
                    Text("marry")
                        .font(.headline)
                    
                    Spacer()
                    
                }
                .padding(.vertical, 8)
                
            }
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    .padding(.horizontal, 16)
            )
            Spacer()
        }
        .navigationBarTitle("Switch Account", displayMode: .inline)
    }
}

// Helper for custom rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
