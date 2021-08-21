//
//  Category.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 21.08.2021.
//

import Foundation

class Category {
  let name: String
  var amountSpent: Double
  
  init(name: String) {
    self.name = name
    self.amountSpent = 0
  }
  
  func clearAmountSpent() {
    self.amountSpent = 0
  }
}
