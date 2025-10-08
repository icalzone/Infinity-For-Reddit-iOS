//
//  GalleryOrImgurDescriptionSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-08.
//

import SwiftUI

struct GalleryOrImgurDescriptionSheet: View {
    let title: String?
    let description: String
    let link: String?
    
    var body: some View {
        ScrollView {
            VStack {
                if let title, !title.isEmpty {
                    RowText(title)
                }
                
                if !description.isEmpty {
                    RowText(description)
                }
                
                if let link, !link.isEmpty {
                    RowText(link)
                }
            }
        }
    }
}
