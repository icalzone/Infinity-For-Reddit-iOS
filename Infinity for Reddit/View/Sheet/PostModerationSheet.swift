//
//  PostModerationSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-24.
//

import SwiftUI

struct PostModerationSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let onApprove: () -> Void
    let onRemove: () -> Void
    let onToggleSpam: () -> Void
    let onToggleStickyPost: () -> Void
    let onLock: () -> Void
    let onToggleSensitive: () -> Void
    let onToggleSpoiler: () -> Void
    let onToggleDistinguishAsModerator: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Moderation")
                    .primaryText()
                
                Spacer()
                    .frame(height: 16)
                
                IconTextButton(startIconUrl: "checkmark.shield.fill", text: "Approve") {
                    onApprove()
                    dismiss()
                }
                
                IconTextButton(startIconUrl: "xmark", text: "Remove") {
                    onRemove()
                    dismiss()
                }
                
                IconTextButton(startIconUrl: "trash", text: "Mark as spam") {
                    onToggleSpam()
                    dismiss()
                }
                
                IconTextButton(startIconUrl: "pin", text: "Sticky post") {
                    onToggleStickyPost()
                    dismiss()
                }
                
                IconTextButton(startIconUrl: "lock.fill", text: "Lock") {
                    onLock()
                    dismiss()
                }
                
                IconTextButton(startIconUrl: "eye.trianglebadge.exclamationmark", text: "Mark sensitive") {
                    onToggleSensitive()
                    dismiss()
                }
                
                IconTextButton(startIconUrl: "exclamationmark.triangle.fill", text: "Mark spoiler") {
                    onToggleSpoiler()
                    dismiss()
                }
                
                IconTextButton(startIconUrl: "shield", text: "Distinguish as moderator") {
                    onToggleDistinguishAsModerator()
                    dismiss()
                }
            }
            .padding(.top, 24)
        }
    }
}
