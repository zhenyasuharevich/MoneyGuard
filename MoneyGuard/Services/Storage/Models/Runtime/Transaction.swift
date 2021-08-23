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
  var type: TransactionType { get }
  var date: Date { get }
  var description: String? { get }
  var paymentName: String { get }
}

class GetTransaction: Transaction {
  var type: TransactionType = .getMoney
  var date: Date
  var description: String?
  var paymentName: String

  init(paymentName: String, description: String? = nil) {
    self.date = Date()
    self.paymentName = paymentName
    self.description = description
  }
}

class SendTransaction: Transaction {
  var type: TransactionType = .sendMoney
  var date: Date
  var description: String?
  var paymentName: String
  var categoryName: String

  init(paymentName: String, categoryName: String, description: String? = nil) {
    self.date = Date()
    self.paymentName = paymentName
    self.description = description
    self.categoryName = categoryName
  }
}
