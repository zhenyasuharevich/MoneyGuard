//
//  StTransaction.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 23.08.2021.
//

import Foundation

class StTransaction: Object {
  @objc dynamic var identifier: String = ""
  @objc dynamic var amount: Double = 0
  @objc dynamic var date: Date = Date()
  @objc dynamic var transactionDescription: String?
  @objc dynamic var type: String = ""
  @objc dynamic var paymentName: String = ""
  @objc dynamic var categoryName: String?
  
  convenience init(identifier: String, date: Date, description: String?, type: TransactionType, paymentName: String, categoryName: String?) {
    self.init()
    self.identifier = identifier
    self.date = date
    self.transactionDescription = description
    self.paymentName = paymentName
    self.categoryName = categoryName
    self.type = type.rawValue
  }
  
  public override class func primaryKey() -> String? {
    "identifier"
  }
}

extension StTransaction: StorableProtocol {
  func createRuntimeModel() -> RunTimeModelProtocol {
    let transactionType = TransactionType(rawValue: self.type) ?? .unowned
    
    return Transaction(identifier: self.identifier,
                       amount: self.amount,
                       type: transactionType,
                       date: self.date,
                       paymentName: self.paymentName,
                       categoryName: self.categoryName,
                       description: self.description)
  }
  
  func getIdentifier() -> String {
    self.identifier
  }
  
}
