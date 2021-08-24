//
//  Category.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 21.08.2021.
//

import Foundation

class Category {
  let identifier: String
  let name: String
  var amountSpent: Double
  
  init(identifier: String, name: String, amountSpent: Double) {
    self.identifier = identifier
    self.name = name
    self.amountSpent = amountSpent
  }
  
  func clearAmountSpent() {
    self.amountSpent = 0
  }
}

extension Category: RunTimeModelProtocol {
  static func storableType() -> StorableProtocol.Type {
    StCategory.self
  }
  
  func convertToStorable() -> StorableProtocol {
    return StCategory(identifier: self.identifier,
                      name: self.name,
                      amountSpent: self.amountSpent)
  }
}
