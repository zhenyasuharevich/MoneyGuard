//
//  StatsModel.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 24/11/2021.
//

import Foundation

struct StatsPresenter {
  let transactions: [Transaction]
  let categories: [Category]
  let payments: [Payment]
  
  func getSummaryStatsModel(for period: Period) -> SummaryStatsModel {
    let dateRange = period.getDateRange()
    
    let sortedTransactions = transactions.filter { $0.date > dateRange.startDate && $0.date < dateRange.endDate }
    
    let incomeTransactions = sortedTransactions.filter { $0.type == .getMoney }
    let spendTransactions = sortedTransactions.filter { $0.type == .sendMoney }
    
    var summaryIncome: Double = 0
    var summarySpend: Double = 0
    
    for transaction in incomeTransactions {
      summaryIncome += transaction.amount
    }
    
    for transaction in spendTransactions {
      summarySpend += transaction.amount
    }
    
    return SummaryStatsModel(income: Int(summaryIncome),
                             spend: Int(summarySpend))
  }
  
  func getCategoriesWithAmount(for period: Period) -> [Category] {
    let range = period.getDateRange()
    let sortedSpendTransactions = transactions.filter { $0.date > range.startDate && $0.date < range.endDate && $0.type == .sendMoney }
    
    var categoriesDict: [String : Double] = [:]
    
    for transaction in sortedSpendTransactions {
      if let categoryName = transaction.categoryName {
        if let amountForCategory = categoriesDict[categoryName] {
          categoriesDict[categoryName] = amountForCategory + transaction.amount
        } else {
          categoriesDict[categoryName] = transaction.amount
        }
      }
    }
    
    return categoriesDict.map { Category(identifier: UUID().uuidString, name: $0.key, amountSpent: $0.value) }
  }
  
  func getPaymentsWithSpendAmount(for period: Period) -> [Payment] {
    let range = period.getDateRange()
    let sortedSpendTransactions = transactions.filter { $0.date > range.startDate && $0.date < range.endDate && $0.type == .sendMoney }
    
    var paymentsDict: [String : Double] = [:]
    
    for transaction in sortedSpendTransactions {
      if let paymentAmount = paymentsDict[transaction.paymentName] {
        paymentsDict[transaction.paymentName] = paymentAmount + transaction.amount
      } else {
        paymentsDict[transaction.paymentName] = transaction.amount
      }
    }
    
    return paymentsDict.map { Payment(identifier: UUID().uuidString, name: $0.key, amount: $0.value, type: .other) }
  }
  
  func getPaymentsWithGetAmount(for period: Period) -> [Payment] {
    let range = period.getDateRange()
    let sortedSpendTransactions = transactions.filter { $0.date > range.startDate && $0.date < range.endDate && $0.type == .getMoney }
    
    var paymentsDict: [String : Double] = [:]
    
    for transaction in sortedSpendTransactions {
      if let paymentAmount = paymentsDict[transaction.paymentName] {
        paymentsDict[transaction.paymentName] = paymentAmount + transaction.amount
      } else {
        paymentsDict[transaction.paymentName] = transaction.amount
      }
    }
    
    return paymentsDict.map { Payment(identifier: UUID().uuidString, name: $0.key, amount: $0.value, type: .other) }
  }

}
