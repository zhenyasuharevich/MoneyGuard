//
//  Payment.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 21.08.2021.
//

import Foundation

enum PaymentType {
  case cash
  case card
  case onlineWallet
  case other
}

class Payment {
  let name: String
  let amount: Double
  let type: PaymentType
  
  init(name: String, amount: Double, type: PaymentType) {
    self.name = name
    self.amount = amount
    self.type = type
  }
}
