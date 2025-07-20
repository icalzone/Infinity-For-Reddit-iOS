//
//  TestView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI
import SDWebImageSwiftUI

struct DummyListItem: Identifiable {
    let id: Int // The Int itself serves as the unique identifier
    // Add any other dummy properties you might need for your ItemView later
    // var someText: String
    // var imageUrl: URL? // If you plan to use WebImage with it
}

struct TestView: View {
    @State private var items: [DummyListItem] = (0..<5).map { DummyListItem(id: $0) }
    
    var body: some View {
//        MultiColumnList(items: items, numberOfColumns: 1, viewForItem: { item, width in
//            AnyView(WebImage(url: URL(string: "https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA")) { image in
//                image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
//            } placeholder: {
//                Rectangle().foregroundColor(.gray)
//            }
//            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
//            .onSuccess { image, data, cacheType in
//                // Success
//                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
//            }
//            .indicator(.activity) // Activity Indicator
//            .transition(.fade(duration: 0.5)) // Fade Transition with duration
//            .scaledToFit()
//            .aspectRatio(CGSize(width: 1000, height: 523), contentMode: .fit)
//            .frame(maxWidth: .infinity)
//            //.frame(width:width, height: CGFloat(width) / (CGFloat(1000) / CGFloat(523)), alignment: .leading)
//            //                    .onAppear {
//            //                        print("fuck you \(width) \(CGFloat(width) / (CGFloat(1000) / CGFloat(523)))")
//            //                    }
//            
//            .background(Color.yellow))
//        })
        
        NavigationSplitView {
            List(0..<10) { item in
                Text("Row \(item)")
            }
        } detail: {
            Text("fuck")
        }
    }
}
