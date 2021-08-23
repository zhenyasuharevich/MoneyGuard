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
}

protocol Transaction {
  var identifier: String { get }
  var type: TransactionType { get }
  var date: Date { get }
  var description: String? { get }
  var paymentName: String { get }
}

class GetTransaction: Transaction {
  var identifier: String
  var type: TransactionType = .getMoney
  var date: Date
  var description: String?
  var paymentName: String

  init(identifier: String, date: Date, paymentName: String, description: String? = nil) {
    self.identifier = identifier
    self.date = date
    self.paymentName = paymentName
    self.description = description
  }
}

class SendTransaction: Transaction {
  var identifier: String
  var type: TransactionType = .sendMoney
  var date: Date
  var description: String?
  var paymentName: String
  var categoryName: String

  init(identifier: String, date: Date, paymentName: String, categoryName: String, description: String? = nil) {
    self.identifier = identifier
    self.date = date
    self.paymentName = paymentName
    self.description = description
    self.categoryName = categoryName
  }
}

extension GetTransaction: RunTimeModelProtocol {
  static func storableType() -> StorableProtocol.Type {
    StTransaction.self
  }
  
  func convertToStorable() -> StorableProtocol {
    StTransaction(identifier: self.identifier,
                  date: self.date,
                  description: self.description,
                  type: .getMoney,
                  paymentName: self.paymentName,
                  categoryName: nil)
  }
}

extension SendTransaction: RunTimeModelProtocol {
  static func storableType() -> StorableProtocol.Type {
    StTransaction.self
  }
  
  func convertToStorable() -> StorableProtocol {
    StTransaction(identifier: self.identifier,
                  date: self.date,
                  description: self.description,
                  type: .sendMoney,
                  paymentName: self.paymentName,
                  categoryName: self.categoryName)
  }
}
