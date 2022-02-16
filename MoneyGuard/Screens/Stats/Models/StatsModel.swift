//
//  StatsModel.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 24/11/2021.
//

import Foundation

struct StatsModel {
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
  

}
