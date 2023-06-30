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
            case "ALL": self = .all
            case "MINE": self = .mine
            case "TEAM": self = .team
            case "OTHERS": self = .others
            default: return nil
        }
    }
  
    var rawValue: RawValue {
        switch self {
            case .all: return "ALL"
            case .mine: return "MINE"
            case .team: return "TEAM"
            case .others: return "OTHERS"
        }
    }
}
