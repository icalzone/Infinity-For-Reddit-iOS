//
//  GalleryOrImgurDescriptionSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-08.
//

import SwiftUI
import MarkdownUI

struct GalleryOrImgurDescriptionSheet: View {
    @EnvironmentObject private var customThemeViewModel: CustomThemeViewModel
    
    let title: String?
    let description: String
    let link: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let title, !title.isEmpty {
                    RowText(title)
                        .font(.system(size: 24, weight: .bold))
                }
                
                if !description.isEmpty {
                    Markdown(description)
                        .markdownTheme(Theme().link {
                            ForegroundColor(Color(hex: customThemeViewModel.currentCustomTheme.colorAccent))
                        }.text {
                            ForegroundColor(Color(hex: customThemeViewModel.currentCustomTheme.primaryTextColor))
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .markdownLinkHandler { url in
                            UIApplication.shared.open(url)
                        }
                }
                
                if let link, !link.isEmpty {
                    RowText(link)
                }
            }
            .padding(16)
        }
        .rootViewBackground()
    }
}
