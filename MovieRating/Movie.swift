//
//  Movie.swift
//  MovieRating
//
//  Created by cagatay_personal on 11.05.19.
//  Copyright © 2019 cagatay. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    var id: String?
    var name: String?
    var rating: Rating = .NONE
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
    }
}

enum Rating: Int, Codable, CaseIterable {
    case NONE = 0
    case VERY_LOW = 1
    case LOW = 2
    case MEDIUM = 3
    case HIGH = 4
    case VERY_HIGH = 5
    
    func getStringValue() -> String {
        switch self {
        case .NONE:
            return "Not rated"
        case .VERY_LOW:
            return "1 Star"
        case .LOW:
            return "2 Star"
        case .MEDIUM:
            return "3 Star"
        case .HIGH:
            return "4 Star"
        case .VERY_HIGH:
            return "5 Star"
        }
    }
}
