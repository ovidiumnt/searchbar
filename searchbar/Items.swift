//
//  Items.swift
//  searchbar
//
//  Created by Ovidiu P. Muntean on 30.06.2023.
//

import Foundation

struct Items: Decodable {
    let name: String
    let category: Category
  
    enum Category: Decodable {
        case all
        case mine
        case team
        case others
    }
}

extension Items.Category: RawRepresentable {
    typealias RawValue = String
  
    init?(rawValue: RawValue) {
        switch rawValue {
            case "All": self = .all
            case "Mine": self = .mine
            case "Team": self = .team
            case "Others": self = .others
            default: return nil
        }
    }
  
    var rawValue: RawValue {
        switch self {
            case .all: return "All"
            case .mine: return "Mine"
            case .team: return "Team"
            case .others: return "Others"
        }
    }
}
