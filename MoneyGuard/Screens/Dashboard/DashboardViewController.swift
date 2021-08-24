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
  private let topBarView = UIView()
  private let categoriesView = CategoriesView()
  
  
  private let changeThemeButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
    setupActions()
  }
  
  override func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    super.setupColorTheme(colorTheme, theme)
    
    paymentsView.setupColorTheme(colorTheme, theme)
    categoriesView.setupColorTheme(colorTheme, theme)
    topBarView.backgroundColor = colorTheme.cellBackgroundColor
    changeThemeButton.backgroundColor = colorTheme.activeColor
  }
  
  @objc private func changeThemeButtonPressed() {
    switch colorSchemeManager.currentTheme {
    case .dark:
      colorSchemeManager.currentTheme = .light
    case .light:
      colorSchemeManager.currentTheme = .system
    case .system:
      colorSchemeManager.currentTheme = .dark
    }
  }
  
}

extension DashboardViewController {
  private func setupSubviews() {
    
    view.addSubview(paymentsView)
    view.addSubview(topBarView)
    view.addSubview(changeThemeButton)
    view.addSubview(categoriesView)
    
    paymentsView.delegate = self
    categoriesView.delegate = self
    
    topBarView.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(100)
    }
    
    changeThemeButton.snp.makeConstraints { make in
      make.trailing.equalTo(topBarView.snp.trailing).offset(-20)
      make.bottom.equalTo(topBarView.snp.bottom).offset(-20)
      make.width.equalTo(32)
      make.height.equalTo(32)
    }
    
    paymentsView.snp.makeConstraints {make in
      make.top.equalTo(topBarView.snp.bottom).offset(20) //.offset(60)
      make.trailing.equalToSuperview()
      make.leading.equalToSuperview()
      make.height.equalTo(212) //title with button 36 + 176 collection
    }
    
    categoriesView.snp.makeConstraints {make in
      make.top.equalTo(paymentsView.snp.bottom).offset(20)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(124) //title with button 36 + 88 collection
    }
  }
  
  private func setupActions() {
    changeThemeButton.addTarget(self, action: #selector(changeThemeButtonPressed), for: .touchUpInside)
  }
}

extension DashboardViewController: PaymentsViewDelegate {
  func paymentPressed(for indexPath: IndexPath) { print(#line, #function, "Payment pressed with indexPath: \(indexPath)") }
  func addPaymentPressed(for indexPath: IndexPath) { print(#line, #function, "Add payment pressed with indexPath: \(indexPath)") }
  func showMorePaymentsPressed() { print(#line,#function,"Title pressed") }
}

extension DashboardViewController: CategoriesViewDelegate {
  func categoryPressed(for indexPath: IndexPath) { print(#line, #function, "Category pressed with indexPath: \(indexPath)") }
  func addCategoryPressed(for indexPath: IndexPath) { print(#line, #function, "Add category pressed with indexPath: \(indexPath)") }
  func showMoreCategoriesPressed() { print(#line,#function,"Title pressed") }
}
