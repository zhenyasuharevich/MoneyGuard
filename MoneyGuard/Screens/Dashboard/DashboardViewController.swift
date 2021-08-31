//
//  ViewController.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 27.07.2021.
//

import UIKit
import SnapKit

enum DashboardState {
  case normal
  case transactionButtonPressed
}

final class DashboardViewController: BaseController {
  
  private let mainScrollView = UIScrollView()
  private let topBarView = TopBarView()
  private let paymentsView = PaymentsView()
  private let categoriesView = CategoriesView()
  private let lastTransactions = LastTransactionsView()
  
  private let addCategoryView = AddCategoryView() // EDIT
  private let addPaymentView = AddPaymentView()
  
  private let transactionButton = UIButton()
  private let addTransactionButton = UIButton()
  private let sendTransactionButton = UIButton()
  private let overlayView = UIView()
  
  private var state: DashboardState {
    didSet {
      switch state {
      case .normal:
        transactionButton.setTitle("T", for: .normal)
        addTransactionButton.isHidden = true
        sendTransactionButton.isHidden = true
        overlayView.isHidden = true
      case .transactionButtonPressed:
        transactionButton.setTitle("X", for: .normal)
        overlayView.isHidden = false
        addTransactionButton.isHidden = false
        sendTransactionButton.isHidden = false
      }
    }
  }
  
  override init(serviceLocator: BaseController.ServiceLocator = ServiceLocator()) {
    self.state = .normal
    super.init()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
  }
  
  override func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    super.setupColorTheme(colorTheme, theme)
  
    topBarView.setupColorTheme(colorTheme, theme)
    categoriesView.setupColorTheme(colorTheme, theme)
    paymentsView.setupColorTheme(colorTheme, theme)
    lastTransactions.setupColorTheme(colorTheme, theme)
    
    addCategoryView.setupColorTheme(colorTheme, theme) // EDIT
    addPaymentView.setupColorTheme(colorTheme, theme)
    
    transactionButton.backgroundColor = colorTheme.activeColor
    addTransactionButton.backgroundColor = colorTheme.activeColor
    sendTransactionButton.backgroundColor = colorTheme.activeColor
  }
  
  @objc private func transactionButtonPressed() {
    switch state {
    case .transactionButtonPressed:
      self.state = .normal
    default:
      self.state = .transactionButtonPressed
    }
  }
  
  @objc private func addTransactionButtonPressed() {
    print("Add transaction")
  }
  
  @objc private func sendTransactionButtonPressed() {
    print("Send transaction")
  }
  
}

extension DashboardViewController {
  private func setupSubviews() {
    let scrollContentView = UIView()
    
    let helperView = UIView() // Remove when all elements will be connected
    
    //Under overlayView
    view.addSubview(mainScrollView)
    view.addSubview(topBarView)
    view.addSubview(overlayView)
    
    //Over overlayView
    view.addSubview(transactionButton)
    view.addSubview(addTransactionButton)
    view.addSubview(sendTransactionButton)
    
    mainScrollView.addSubview(scrollContentView)
    
    scrollContentView.addSubview(paymentsView)
    scrollContentView.addSubview(lastTransactions)
    scrollContentView.addSubview(categoriesView)
    
    scrollContentView.addSubview(helperView)
//    scrollContentView.addSubview(addCategoryView)
    scrollContentView.addSubview(addPaymentView)
    
    topBarView.delegate = self
    paymentsView.delegate = self
    categoriesView.delegate = self
    lastTransactions.delegate = self
    
    transactionButton.addTarget(self, action: #selector(transactionButtonPressed), for: .touchUpInside)
    addTransactionButton.addTarget(self, action: #selector(addTransactionButtonPressed), for: .touchUpInside)
    sendTransactionButton.addTarget(self, action: #selector(sendTransactionButtonPressed), for: .touchUpInside)
    
    topBarView.snp.makeConstraints { make in
      make.top.trailing.leading.equalToSuperview()
      make.height.equalTo(DashboardConstants.TopBar.height)
    }
    
    overlayView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    overlayView.isHidden = true
    overlayView.backgroundColor = .black
    overlayView.alpha = 0.7
    
    transactionButton.snp.makeConstraints { make in
      make.width.height.equalTo(72)
      make.bottom.equalToSuperview().offset(-32)
      make.centerX.equalToSuperview()
    }
    
    transactionButton.layer.cornerRadius = 72 / 2
    transactionButton.layer.borderWidth = 1
    transactionButton.setTitle("T", for: .normal)
    transactionButton.titleLabel?.font = .systemFont(ofSize: 40, weight: .bold)
    transactionButton.titleLabel?.textColor = .white
    transactionButton.layer.borderColor = UIColor.white.cgColor
    
    addTransactionButton.snp.makeConstraints { make in
      make.height.equalTo(60)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalTo(transactionButton.snp.top).offset(-16)
    }
    addTransactionButton.isHidden = true
    addTransactionButton.layer.cornerRadius = 20
    addTransactionButton.layer.borderWidth = 1
    addTransactionButton.setTitle("Spend money", for: .normal)
    addTransactionButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
    addTransactionButton.titleLabel?.textColor = .white
    addTransactionButton.layer.borderColor = UIColor.white.cgColor
    
    sendTransactionButton.snp.makeConstraints { make in
      make.height.equalTo(60)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalTo(addTransactionButton.snp.top).offset(-16)
    }
    sendTransactionButton.isHidden = true
    sendTransactionButton.layer.cornerRadius = 20
    sendTransactionButton.layer.borderWidth = 1
    sendTransactionButton.setTitle("Add money", for: .normal)
    sendTransactionButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
    sendTransactionButton.titleLabel?.textColor = .white
    sendTransactionButton.layer.borderColor = UIColor.white.cgColor
    
    mainScrollView.snp.makeConstraints { make in
      make.top.equalTo(topBarView.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
    
    scrollContentView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
      make.left.right.equalTo(view)
    }
    
    paymentsView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(DashboardConstants.PaymentsComponent.topOffset)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(DashboardConstants.PaymentsComponent.height)
    }
    
    categoriesView.snp.makeConstraints {make in
      make.top.equalTo(paymentsView.snp.bottom).offset(DashboardConstants.CategoriesComponent.topOffset)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(DashboardConstants.CategoriesComponent.height)
    }
    
    lastTransactions.snp.makeConstraints { make in
      make.top.equalTo(categoriesView.snp.bottom).offset(DashboardConstants.LastTransactionsComponent.topOffset)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(DashboardConstants.LastTransactionsComponent.height)
    }
    
//    addCategoryView.snp.makeConstraints { make in
//      make.top.equalTo(lastTransactions.snp.bottom).offset(20)
//      make.trailing.equalToSuperview().offset(-16)
//      make.leading.equalToSuperview().offset(16)
//      make.height.equalTo(188)
//    }
    
    addPaymentView.snp.makeConstraints { make in
      make.top.equalTo(lastTransactions.snp.bottom).offset(20)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(496)
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

extension DashboardViewController: CategoriesViewDelegate {
  func categoryPressed(for indexPath: IndexPath) { print(#line, #function, "Category pressed with indexPath: \(indexPath)") }
  func addCategoryPressed(for indexPath: IndexPath) { print(#line, #function, "Add category pressed with indexPath: \(indexPath)") }
  func showMoreCategoriesPressed() { print(#line,#function,"Title pressed") }
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
    static var topOffset: CGFloat = 20
  }
  
  struct LastTransactionsComponent {
    static var height: CGFloat = 396 //title with button 36 + 6 cells(every cell with 60 height)
    static var topOffset: CGFloat = 20
  }
  
  struct MainScrollView {
    static var contentHeight: CGFloat = PaymentsComponent.height + LastTransactionsComponent.height + 500 + 20 + 20 + 20
  }
  
  struct CategoriesComponent {
    static var height: CGFloat = 124 //title with button 36 + 88 collection
    static var topOffset: CGFloat = 20
  }

}
