//
//  StatsController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 10/11/2021.
//

import UIKit
import AAInfographics
import SwiftUI

final class StatsController: UIViewController {
  
  private let mainScrollView = UIScrollView()
  private let scrollContentView = UIView()
  
  private let topBar = TopBar(title: "Stats")
  private let summaryStatsView = SummaryStatView()
  private let barChart = AAChartView()
  private let secondBarChart = AAChartView()
  
  private var statsModel: StatsPresenter
  
  init(transactions: [Transaction],
       categories: [Category],
       payments: [Payment]) {
    self.statsModel = StatsPresenter(transactions: transactions, categories: categories, payments: payments)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    setupSubviews()
    if let period = summaryStatsView.getPeriod() {
      setupData(for: period)
      statsModel.getCategoriesWithAmount(for: period)
    }
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    view.backgroundColor = colorTheme.backgroundColor
    topBar.setupColorTheme(colorTheme, theme)
    summaryStatsView.setupColorTheme(colorTheme, theme)
  }
  
  func setupData(for period: Period) {
    summaryStatsView.isUserInteractionEnabled = false
    
    let summaryStatsObject = statsModel.getSummaryStatsModel(for: period)
    
    summaryStatsView.setData(object: summaryStatsObject)
    summaryStatsView.isUserInteractionEnabled = true
  
    let chartData = ChartData(statsModel: statsModel)
    
    setupBarChart(for: period, chartData: chartData, chartType: .column, chartView: barChart)
    
    setupBarChart(for: period, chartData: chartData, chartType: .area, chartView: secondBarChart)
  }
  
  func setupCategories(period: Period) -> [String]  {
    var categories: [String] = []
    let dateRange = period.getDateRange()
    
    var startDate = dateRange.startDate
    
    switch period {
      
    case .week:
      while startDate <= dateRange.endDate {
        startDate += TimeInterval(60*60*24)
        categories.append(startDate.dayOfWeek())
      }
    case .month:
      break
    case .year:
      while startDate < dateRange.endDate {
        startDate += TimeInterval(60*60*24*30.4)
        categories.append(startDate.monthOfYear())
      }
    }
    
    return categories
  }
  
//  func setupChartModel() -> AAChartModel {
//    let model = AAChartModel()
//      .chartType(.bar)
//      .animationType(.bounce)
//      .dataLabelsEnabled(false)
//      .touchEventEnabled(true)
//
//    return model
//  }
  
  func setupBarChart(for period: Period, chartData: ChartData,chartType: AAChartType, chartView: AAChartView) {
   
    let model = AAChartModel()
      .chartType(chartType)
      .animationType(.bounce)
      .dataLabelsEnabled(false)
      .touchEventEnabled(true)

    switch period {
      
    case .week :
      let categories = setupCategories(period: period)
      let weekTransactions = chartData.setupWeekTransactions()
      
      model.categories(categories)
        .series([
          AASeriesElement()
            .name("Incomes")
            .data(weekTransactions.income),
          AASeriesElement()
            .name("Еxpenses")
            .data(weekTransactions.spend)
        ])
      
    case .month :
      let monthTransactions = chartData.setupMonthTransactions()
      let weeks = ["First", "Second", "Third", "Fourth", "Fifth"]
      
      model.categories(weeks)
        .series([
          AASeriesElement()
            .name("Incomes")
            .data(monthTransactions.income),
          AASeriesElement()
            .name("Еxpenses")
            .data(monthTransactions.spend)
        ])
      
    case .year :
      let categories = setupCategories(period: period)
      let yearTransactions = chartData.setupYearTransactions()
      
      model.categories(categories)
        .series([
          AASeriesElement()
            .name("Incomes")
            .data(yearTransactions.income),
          AASeriesElement()
            .name("Еxpenses")
            .data(yearTransactions.spend)
        ])
    }
    
    model.colorsTheme(["#52CC39","#D23030"])
    
    chartView.aa_drawChartWithChartModel(model)
  }
  
}

extension StatsController {
  
  private func setupSubviews() {
    
    view.addSubview(mainScrollView)
    view.addSubview(topBar)
    
    mainScrollView.addSubview(scrollContentView)
    
    scrollContentView.addSubview(summaryStatsView)
    scrollContentView.addSubview(barChart)
    scrollContentView.addSubview(secondBarChart)
    
    topBar.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(DashboardConstants.TopBar.height)
    }
    
    topBar.layer.cornerRadius = 20
    topBar.layer.masksToBounds = true
    topBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    topBar.delegate = self
    
    mainScrollView.snp.makeConstraints { make in
      make.top.equalTo(topBar.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
    
    scrollContentView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
      make.height.equalTo(1200)
      make.left.right.equalTo(view)
    }
    
    summaryStatsView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.leading.equalTo(16)
      make.trailing.equalTo(-16)
      make.height.equalTo(124)
    }
    summaryStatsView.delegate = self
    
    barChart.snp.makeConstraints { make in
      make.top.equalTo(summaryStatsView.snp.bottom).offset(20)
      make.leading.equalTo(8)
      make.trailing.equalTo(-8)
      make.height.equalTo(296)
    }
    barChart.isClearBackgroundColor = true
    

    secondBarChart.snp.makeConstraints { make in
      make.top.equalTo(barChart.snp.bottom).offset(40)
      make.leading.equalTo(8)
      make.trailing.equalTo(-8)
      make.height.equalTo(300)
    }
    secondBarChart.isClearBackgroundColor = true
  }
  
}

extension StatsController: SummaryStatViewDelegate {
  func statsViewPeriodDidChange(newPeriod: Period) {
    setupData(for: newPeriod)
  }
}

extension StatsController: TopBarDelegate {
  func returnButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
}
