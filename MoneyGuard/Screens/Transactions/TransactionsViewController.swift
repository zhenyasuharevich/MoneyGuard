//
//  TransactionsViewController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 25/09/2021.
//

import UIKit

protocol TransactionsViewControllerDelegate: AnyObject {
  func addTransactionChoosePaymentPressed()
  func addTransactionChooseCategoryPressed()
}

class TransactionsViewController: UIViewController {
  
  private let topBar = UIView()
  private let returnButton = UIButton()
  private let screenNameLabel = UILabel()
  
  weak var delegate: TransactionsViewControllerDelegate?
  
  private var currentTheme: ThemeType?
  private var currentColorTheme: ColorThemeProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
  }

  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    
    topBar.backgroundColor = colorTheme.formBackgroundColor
    view.backgroundColor = colorTheme.backgroundColor
    returnButton.setTitleColor(colorTheme.textColor, for: .normal)
    screenNameLabel.textColor = colorTheme.textColor
    
  }
  
  @objc private func returnButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
  
}



extension TransactionsViewController {
  private func setupSubviews() {
    
    view.addSubview(topBar)
    topBar.addSubview(returnButton)
    topBar.addSubview(screenNameLabel)
    
    //view.backgroundColor = .clear
    
    topBar.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(DashboardConstants.TopBar.height)
    }
    
    topBar.layer.cornerRadius = 20
    topBar.layer.masksToBounds = true
    topBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    
    returnButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-28)
      make.leading.equalToSuperview().offset(28)
      make.height.equalTo(24)
      make.width.equalTo(24)
    }
    
    returnButton.setTitle("←", for: .normal)
    returnButton.addTarget(self, action: #selector(returnButtonPressed), for: .touchUpInside)
    returnButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
    
    screenNameLabel.snp.makeConstraints { make in
      make.centerY.equalTo(returnButton)
      make.centerX.equalToSuperview()
    }
    
    screenNameLabel.font = .systemFont(ofSize: 20, weight: .medium)
    screenNameLabel.text = "All transactions"
    
  }
}
