//
//  UserDetailsViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-02-11.
//  

import Foundation
import GRDB
import Combine
import Swinject

class UserDetailsViewModel: ObservableObject {
    
    func formattedCakeDay(_ timestamp: TimeInterval?) -> String {
            guard let timestamp = timestamp else {
                return "Unknown"
            }

            let date = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()

            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none

            return dateFormatter.string(from: date)
        }
}
