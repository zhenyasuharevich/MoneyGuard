//
//  Transaction.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 21.08.2021.
//

import Foundation

enum TransactionType: String {
  case sendMoney
  case getMoney
  case unowned
}

class Transaction {
  let identifier: String
  let type: TransactionType
  let date: Date
  let description: String?
  let paymentName: String
  let categoryName: String? 
  
  init(identifier: String, type: TransactionType, date: Date, paymentName: String, categoryName: String?, description: String? = nil) {
    self.identifier = identifier
    self.type = type
    self.date = date
    self.paymentName = paymentName
    self.description = description
    self.categoryName = categoryName
  }
}

extension Transaction: RunTimeModelProtocol {
  static func storableType() -> StorableProtocol.Type {
    StTransaction.self
  }
  
  func convertToStorable() -> StorableProtocol {
    StTransaction(identifier: self.identifier,
                  date: self.date,
                  description: self.description,
                  type: self.type,
                  paymentName: self.paymentName,
                  categoryName: self.categoryName)
  }
}
