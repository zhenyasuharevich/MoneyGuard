//
//  Payment.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 21.08.2021.
//

import Foundation

enum PaymentType: String {
  case cash
  case card
  case onlineWallet
  case other
}

class Payment {
  let identifier: String
  let name: String
  let amount: Double
  let type: PaymentType
  
  init(identifier: String, name: String, amount: Double, type: PaymentType) {
    self.identifier = identifier
    self.name = name
    self.amount = amount
    self.type = type
  }
}

extension Payment: RunTimeModelProtocol {
  static func storableType() -> StorableProtocol.Type {
    StPayment.self
  }
  
  func convertToStorable() -> StorableProtocol {
    return StPayment(identifier: self.identifier,
                     name: self.name,
                     amount: self.amount,
                     type: self.type.rawValue)
  }
}
