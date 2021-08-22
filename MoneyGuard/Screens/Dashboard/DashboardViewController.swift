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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
  }
  
    override func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
      super.setupColorTheme(colorTheme, theme)
  
      paymentsView.setupColorTheme(colorTheme, theme)
      topBarView.backgroundColor = colorTheme.cellBackgroundColor
    }
  
}

extension DashboardViewController {
  private func setupSubviews() {
    
    view.addSubview(paymentsView)
    view.addSubview(topBarView)
    
    paymentsView.delegate = self
    
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
  }
  
}

extension DashboardViewController: PaymentsViewDelegate {
  func paymentPressed(for indexPath: IndexPath) { print(#line, #function, "Payment pressed with indexPath: \(indexPath)") }
  func addPaymentPressed(for indexPath: IndexPath) { print(#line, #function, "Add payment pressed with indexPath: \(indexPath)") }
  func showMorePaymentsPressed() { print(#line,#function,"Title pressed") }
}