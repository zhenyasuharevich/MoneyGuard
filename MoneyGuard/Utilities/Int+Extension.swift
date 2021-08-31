//
//  Int+Extension.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 31.08.2021.
//

import Foundation

extension Int {
  var roundedWithName: String {
    let number = Double(self)
    let thousand = number / 1000
    let million = number / 1000000
    if million >= 1.0 {
      return "\(round(million*10)/10)M"
    }
    else if thousand >= 1.0 {
      return "\(round(thousand*10)/10)K"
    }
    else {
      return "\(self)"
    }
  }
}
