//
//  ChartData.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 16/02/2022.
//

import Foundation

class ChartData {
  
  private var statsPresenter: StatsPresenter
  
  init(statsPresenter: StatsPresenter) {
    self.statsPresenter = statsPresenter
  }

  func setupWeekTransactions() -> ChartStatsModel {
    let period = Period.week
    let dateRange = period.getDateRange()
    
    var weekIncomes: [Double] = []
    var weekExpenses: [Double] = []
    
    var startDate = dateRange.startDate
    
    while startDate < dateRange.endDate {
      startDate += TimeInterval(60*60*24)
      
      var allTransactions: [Transaction] = []
      statsPresenter.transactions.forEach { transaction in
        let order = Calendar.current.compare(transaction.date, to: startDate, toGranularity: .day)
        
        if order == .orderedSame {
          allTransactions.append(transaction)
        }
      }
      
      let summary = addAllTransactions(allTransactions: allTransactions)
      
      weekIncomes.append(summary.income)
      weekExpenses.append(summary.spend)
      
    }
    
    return ChartStatsModel(name: [""], income: weekIncomes,
                             spend: weekExpenses)
  }
  
  func setupMonthTransactions() -> ChartStatsModel {
    let period = Period.month
    let dateRange = period.getDateRange()
    
    var monthIncomes: [Double] = []
    var monthExpenses: [Double] = []
    
    var startDate = dateRange.startDate
    var intermediate = startDate + TimeInterval(60*60*24*7)
    
    while startDate < dateRange.endDate {
      
      var allTransactions: [Transaction] = []
      
      if intermediate >= dateRange.endDate {
        allTransactions = statsPresenter.transactions.filter { $0.date > startDate && $0.date < dateRange.endDate }
      } else {
        allTransactions = statsPresenter.transactions.filter { $0.date > startDate && $0.date < intermediate }
      }
      
      let summary = addAllTransactions(allTransactions: allTransactions)
      
      monthIncomes.append(summary.income)
      monthExpenses.append(summary.spend)
      
      startDate += TimeInterval(60*60*24*7)
      intermediate += TimeInterval(60*60*24*7)
    }
    
    return ChartStatsModel(name: [""], income: monthIncomes,
                             spend: monthExpenses)
  }
  
  func setupYearTransactions() -> ChartStatsModel {
    let period = Period.year
    let dateRange = period.getDateRange()
    
    var yearIncomes: [Double] = []
    var yearExpenses: [Double] = []
    
    var startDate = dateRange.startDate
    var intermediate = startDate + TimeInterval(60*60*24*30.417)
    
    while startDate < dateRange.endDate {
      
      var allTransactions: [Transaction] = []
      
      if intermediate >= dateRange.endDate {
        allTransactions = statsPresenter.transactions.filter { $0.date > startDate && $0.date < dateRange.endDate }
      } else {
        allTransactions = statsPresenter.transactions.filter { $0.date > startDate && $0.date < intermediate }
      }
      
      let summary = addAllTransactions(allTransactions: allTransactions)
      
      yearIncomes.append(summary.income)
      yearExpenses.append(summary.spend)
      
      startDate += TimeInterval(60*60*24*30.417)
      intermediate += TimeInterval(60*60*24*30.417)
    }
  
    return ChartStatsModel(name: [""], income: yearIncomes,
                             spend: yearExpenses)
  }
  
  func addAllTransactions(allTransactions: [Transaction]) -> ChartPartsModel {
    
    let incomeTransactions = allTransactions.filter { $0.type == .getMoney }
    let spendTransactions = allTransactions.filter { $0.type == .sendMoney }
    
    var summaryIncome: Double = 0
    var summarySpend: Double = 0
    
    for transaction in incomeTransactions {
      summaryIncome += transaction.amount
    }
    
    for transaction in spendTransactions {
      summarySpend += transaction.amount
    }
    
    return ChartPartsModel(income: summaryIncome, spend: summarySpend)
  }
  
  func setupCategoriesWithAmount(period: Period) -> ChartStatsModel {
    let allCategories = statsPresenter.getCategoriesWithAmount(for: period)
  
    var categoriesNames: [String] = []
    var categoriesAmounts: [Double] = []
    
    allCategories.forEach { category in
      categoriesNames.append(category.name)
      categoriesAmounts.append(category.amountSpent)
    }
    
    if categoriesNames.count > 5 && categoriesAmounts.count > 5 {
      categoriesNames = Array(categoriesNames.prefix(5))
      categoriesAmounts = Array(categoriesAmounts.prefix(5))
    }
    
    return ChartStatsModel(name: categoriesNames, income: [0.0], spend: categoriesAmounts)
  }
  
  func setupPaymentsWithSpendAmount(period: Period) -> ChartStatsModel {
    let allPayments = statsPresenter.getPaymentsWithSpendAmount(for: period)
  
    var paymentsNames: [String] = []
    var paymentsAmounts: [Double] = []
    
    allPayments.forEach { payment in
      paymentsNames.append(payment.name)
      paymentsAmounts.append(payment.amount)
    }
    
    if paymentsNames.count > 3 && paymentsAmounts.count > 3 {
      paymentsNames = Array(paymentsNames.prefix(3))
      paymentsAmounts = Array(paymentsAmounts.prefix(3))
    }
    
    return ChartStatsModel(name: paymentsNames, income: [0.0], spend: paymentsAmounts)
  }
  
  func setupPaymentsWithGetAmount(period: Period) -> ChartStatsModel {
    let allPayments = statsPresenter.getPaymentsWithGetAmount(for: period)
  
    var paymentsNames: [String] = []
    var paymentsAmounts: [Double] = []
    
    allPayments.forEach { payment in
      paymentsNames.append(payment.name)
      paymentsAmounts.append(payment.amount)
    }
    
    if paymentsNames.count > 3 && paymentsAmounts.count > 3 {
      paymentsNames = Array(paymentsNames.prefix(3))
      paymentsAmounts = Array(paymentsAmounts.prefix(3))
    }
    
    return ChartStatsModel(name: paymentsNames, income: paymentsAmounts, spend: [0.0])
  }
  
}
