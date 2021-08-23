//
//  ViewController.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 27.07.2021.
//

import UIKit
import SnapKit

final class DashboardViewController: BaseController {
  
  private let paymentsView = PaymentsView()
  private let topBarView = TopBarView()
  private let lastTransactions = LastTransactionsView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
  }
  
    override func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
      super.setupColorTheme(colorTheme, theme)
  
      paymentsView.setupColorTheme(colorTheme, theme)
      topBarView.setupColorTheme(colorTheme, theme)
    }
  
}

extension DashboardViewController {
  private func setupSubviews() {
    
    view.addSubview(paymentsView)
    view.addSubview(topBarView)
    view.addSubview(lastTransactions)
    
    topBarView.delegate = self
    paymentsView.delegate = self
    lastTransactions.delegate = self
    
    topBarView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(0)
      make.trailing.equalToSuperview().offset(0)
      make.leading.equalToSuperview().offset(0)
      make.height.equalTo(UIScreen.main.bounds.height > 736 ? 120 : 100)
    }
    
    paymentsView.snp.makeConstraints {make in
      make.top.equalTo(topBarView.snp.bottom).offset(20) //.offset(60)
      make.trailing.equalToSuperview()
      make.leading.equalToSuperview()
      make.height.equalTo(212) //title with button 36 + 176 collection
    }
    
    lastTransactions.snp.makeConstraints { make in
      make.top.equalTo(paymentsView.snp.bottom).offset(20)
      make.trailing.equalToSuperview()
      make.leading.equalToSuperview()
      make.height.equalTo(396) //title with button 36 + 6 cells(every cell with 60 height)
    }
    
  }
  
}

extension DashboardViewController: TopBarViewDelegate {
  func settingsButtonPressed() {
    switch colorSchemeManager.currentTheme {
    case .light:
      colorSchemeManager.currentTheme = .dark
    case .dark:
      colorSchemeManager.currentTheme = .system
    case .system:
      colorSchemeManager.currentTheme = .light
    }
  }
}

extension DashboardViewController: PaymentsViewDelegate {
  func paymentPressed(for indexPath: IndexPath) { print(#line, #function, "Payment pressed with indexPath: \(indexPath)") }
  func addPaymentPressed(for indexPath: IndexPath) { print(#line, #function, "Add payment pressed with indexPath: \(indexPath)") }
  func showMorePaymentsPressed() { print(#line,#function,"Title pressed") }
}

extension DashboardViewController: LastTransactionsViewDelegate {
  func lastTransactionsPressed(for indexPath: IndexPath) { print("Transaction pressed at: \(indexPath.row)") }
  func showMoreLastTransactionsPressed() { print("Show more transactions pressed") }
}
