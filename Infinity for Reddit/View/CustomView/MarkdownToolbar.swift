//
//  MarkdownToolbar.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-18.
//

import SwiftUI

struct MarkdownToolbar: View {
    @Binding var text: String
    @Binding var selectedRange: NSRange

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                TouchRipple(backgroundShape: Circle(), action: { applyMarkdown("**") }) {
                    SwiftUI.Image(systemName: "bold")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: { applyMarkdown("*") }) {
                    SwiftUI.Image(systemName: "italic")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: { insertLink() }) {
                    SwiftUI.Image(systemName: "link")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: { applyMarkdown("~~") }) {
                    SwiftUI.Image(systemName: "strikethrough")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: { applyMarkdown("^(", ")") }) {
                    SwiftUI.Image(systemName: "textformat.superscript")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: {}) {
                    SwiftUI.Image(systemName: "h.circle")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: { applyMarkdown(left: "1. ") }) {
                    SwiftUI.Image(systemName: "list.number")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: { applyMarkdown(left: "* ") }) {
                    SwiftUI.Image(systemName: "list.bullet")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: { applyMarkdown(">!", "!<")}) {
                    SwiftUI.Image(systemName: "exclamationmark.triangle.fill")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: { applyMarkdown("> ", "\n\n")}) {
                    SwiftUI.Image(systemName: "quote.opening")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: { applyMarkdown("```\n", "\n```\n")}) {
                    SwiftUI.Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: {}) {
                    SwiftUI.Image(systemName: "photo")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: {}) {
                    SwiftUI.Image("gif")
                        .primaryIcon()
                        .padding(16)
                }
            }
        }
    }
    
    private func applyMarkdown(_ wrapper: String) {
        guard let range = Range(selectedRange, in: text) else { return }
        
        let selectedText = String(text[range])
        let newText: String
        if selectedRange.length > 0 {
            newText = text.replacingCharacters(in: range, with: "\(wrapper)\(selectedText)\(wrapper)")
            selectedRange = NSRange(location: selectedRange.location,
                                    length: selectedText.count + wrapper.count * 2)
        } else {
            newText = text.inserting("\(wrapper)\(wrapper)", at: selectedRange.location)
            selectedRange = NSRange(location: selectedRange.location + wrapper.count,
                                    length: 0)
        }
        text = newText
    }
    
    private func applyMarkdown(_ left: String, _ right: String) {
        guard let range = Range(selectedRange, in: text) else { return }
        
        let selectedText = String(text[range])
        let newText: String
        if selectedRange.length > 0 {
            newText = text.replacingCharacters(in: range, with: "\(left)\(selectedText)\(right)")
            selectedRange = NSRange(location: selectedRange.location,
                                    length: selectedText.count + left.count + right.count)
        } else {
            newText = text.inserting("\(left)\(right)", at: selectedRange.location)
            selectedRange = NSRange(location: selectedRange.location + left.count,
                                    length: 0)
        }
        text = newText
    }
    
    private func applyMarkdown(left: String) {
        guard let range = Range(selectedRange, in: text) else { return }
        
        let selectedText = String(text[range])
        let newText: String
        if selectedRange.length > 0 {
            newText = text.replacingCharacters(in: range, with: "\(left)\(selectedText)")
            selectedRange = NSRange(location: selectedRange.location,
                                    length: selectedText.count + left.count)
        } else {
            newText = text.inserting("\(left)", at: selectedRange.location)
            selectedRange = NSRange(location: selectedRange.location + left.count,
                                    length: 0)
        }
        text = newText
    }
    
    private func insertLink() {
        let linkSyntax = "[text](url)"
        text = text.inserting(linkSyntax, at: selectedRange.location)
        selectedRange = NSRange(location: selectedRange.location + 1, length: 4)
    }
}
