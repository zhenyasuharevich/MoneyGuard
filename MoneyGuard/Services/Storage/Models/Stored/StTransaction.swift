//
//  StTransaction.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 23.08.2021.
//

import Foundation

class StTransaction: Object {
  @objc dynamic var identifier: String = ""
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
    var transactionType = TransactionType.getMoney
    
    if let _transactionType = TransactionType(rawValue: type) {
      transactionType = _transactionType
    }
    
    switch transactionType {
    case .getMoney:
      return GetTransaction(identifier: self.identifier,
                            date: self.date,
                            paymentName: self.paymentName,
                            description: self.transactionDescription)
    case .sendMoney:
      if let _categoryName = self.categoryName {
        return SendTransaction(identifier: self.identifier,
                               date: self.date,
                               paymentName: self.paymentName,
                               categoryName: _categoryName,
                               description: self.transactionDescription)
      } else {
        print("Error: Can't get category name for send transaction")
        return SendTransaction(identifier: self.identifier,
                               date: self.date,
                               paymentName: self.paymentName,
                               categoryName: "Error category",
                               description: self.transactionDescription)
      }
      
    }
  }
  
  func getIdentifier() -> String {
    self.identifier
  }
  
}
