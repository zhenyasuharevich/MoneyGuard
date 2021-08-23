//
//  ViewController.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 27.07.2021.
//

import UIKit
import SnapKit

final class DashboardViewController: BaseController {
  
  private let mainScrollView = UIScrollView()
  private let paymentsView = PaymentsView()
  private let topBarView = TopBarView()
  private let lastTransactions = LastTransactionsView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
  }
  
    override func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
      super.setupColorTheme(colorTheme, theme)
  
      topBarView.setupColorTheme(colorTheme, theme)
      paymentsView.setupColorTheme(colorTheme, theme)
      lastTransactions.setupColorTheme(colorTheme, theme)
    }
  
}

extension DashboardViewController {
  private func setupSubviews() {
    let scrollContentView = UIView()
    
    let helperView = UIView() // Remove when all elements will be connected
    
    view.addSubview(mainScrollView)
    view.addSubview(topBarView)
    
    mainScrollView.addSubview(scrollContentView)
    scrollContentView.addSubview(paymentsView)
    scrollContentView.addSubview(lastTransactions)
    scrollContentView.addSubview(helperView)
    
    topBarView.delegate = self
    paymentsView.delegate = self
    lastTransactions.delegate = self
    
    topBarView.snp.makeConstraints { make in
      make.top.trailing.leading.equalToSuperview()
      make.height.equalTo(DashboardConstants.TopBar.height)
    }
    
    mainScrollView.snp.makeConstraints { make in
      make.top.equalTo(topBarView.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
    
    scrollContentView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
      make.left.right.equalTo(view)
    }
    
    paymentsView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(DashboardConstants.PaymentsComponent.height)
    }
    
    lastTransactions.snp.makeConstraints { make in
      make.top.equalTo(paymentsView.snp.bottom).offset(20)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(DashboardConstants.LastTransactionsComponent.height)
    }
    
    
    helperView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(lastTransactions.snp.bottom).offset(20)
      make.height.equalTo(500)
      make.bottom.equalTo(scrollContentView.snp.bottom)
    }
    
    //Bottom element needs to be connected to bottom of scrollContentView
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

struct DashboardConstants {
  
  struct TopBar {
    static var height: CGFloat = UIScreen.main.bounds.height > 736 ? 120 : 100
  }
  
  struct PaymentsComponent {
    static var height: CGFloat = 212 //title with button 36 + 176 collection
  }
  
  struct LastTransactionsComponent {
    static var height: CGFloat = 396 //title with button 36 + 6 cells(every cell with 60 height)
  }
  
  struct MainScrollView {
    static var contentHeight: CGFloat = PaymentsComponent.height + LastTransactionsComponent.height + 500 + 20 + 20 + 20
  }
  
}
