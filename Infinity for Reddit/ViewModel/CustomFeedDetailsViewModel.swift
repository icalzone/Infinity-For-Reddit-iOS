//
//  CustomFeedDetailsViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-27.
//

import Foundation

public class CustomFeedDetailsViewModel: ObservableObject {
    @Published var myCustomFeed: MyCustomFeed
    private let customFeedDetailsRepository: CustomFeedDetailsRepositoryProtocol
    
    init(myCustomFeed: MyCustomFeed, customFeedDetailsRepository: CustomFeedDetailsRepositoryProtocol) {
        self.myCustomFeed = myCustomFeed
        self.customFeedDetailsRepository = customFeedDetailsRepository
    }
}
