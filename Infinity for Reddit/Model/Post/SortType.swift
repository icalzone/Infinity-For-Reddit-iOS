//
//  SortType.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-12.
//

import Foundation

struct SortType {
    enum `Type`: String {
        case best = "best"
        case hot = "hot"
        case new = "new"
        case random = "random"
        case rising = "rising"
        case top = "top"
        case controversial = "controversial"
        case relevance = "relevance"
        case comments = "comments"
        case activity = "activity"
        case confidence = "confidence"
        case old = "old"
        case qa = "qa"
        case live = "live"

        var fullName: String {
            switch self {
            case .best: return "Best"
            case .hot: return "Hot"
            case .new: return "New"
            case .random: return "Random"
            case .rising: return "Rising"
            case .top: return "Top"
            case .controversial: return "Controversial"
            case .relevance: return "Relevance"
            case .comments: return "Comments"
            case .activity: return "Activity"
            case .confidence: return "Best"
            case .old: return "Old"
            case .qa: return "QA"
            case .live: return "Live"
            }
        }
    }

    enum Time: String {
        case hour = "hour"
        case day = "day"
        case week = "week"
        case month = "month"
        case year = "year"
        case all = "all"

        var fullName: String {
            switch self {
            case .hour: return "Hour"
            case .day: return "Day"
            case .week: return "Week"
            case .month: return "Month"
            case .year: return "Year"
            case .all: return "All Time"
            }
        }
    }

    let type: Type
    let time: Time?

    init(type: Type, time: Time? = nil) {
        self.type = type
        self.time = time
    }
}
