//
// NewPostSheet.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-06-28

import SwiftUI

struct NewPostSheet: View {
    var body: some View {
        List {
            Button("Text") {
                print("Create Text Post")
            }
            
            Button("Link") {
                print("Create Link Post")
            }
            
            Button("Video") {
                print("Create Video Post")
            }
            
            Button("Image") {
                print("Create Image Post")
            }
            
            Button("Gallery") {
                print("Create Gallery Post")
            }
            
            Button("Poll") {
                print("Create Poll Post")
            }
        }
    }
}
