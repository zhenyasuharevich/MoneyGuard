//
//  StPayment.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 23.08.2021.
//

import Foundation

class StPayment: Object {
  @objc dynamic var identifier: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var amount: Double = 0
  @objc dynamic var type: String = ""
  
  convenience init(identifier: String, name: String, amount: Double, type: String) {
    self.init()
    self.identifier = identifier
    self.name = name
    self.amount = amount
    self.type = type
  }
  
  public override class func primaryKey() -> String? {
    "identifier"
  }
}

extension StPayment: StorableProtocol {
  func createRuntimeModel() -> RunTimeModelProtocol {
    var paymentType: PaymentType = .other
    
    if let _paymentType = PaymentType(rawValue: type) {
      paymentType = _paymentType
    }
    
    return Payment(identifier: self.identifier,
            name: self.name,
            amount: self.amount,
            type: paymentType)
  }
  
  func getIdentifier() -> String { return self.identifier }
}
