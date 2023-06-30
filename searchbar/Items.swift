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
    case other
  }
}
