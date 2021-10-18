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
  case addPayment
  case addCategory
  case sendTransaction
  case getTransaction
}

final class DashboardViewController: BaseController {
  
  private let mainScrollView = UIScrollView()
  private let topBarView = TopBarView()
  private let statsView = StatsView()
  private let paymentsView = PaymentsView()
  private let categoriesView = CategoriesView()
  private let lastTransactions = LastTransactionsView()
  
  private let addCategoryView = AddCategoryView()
  private let addPaymentView = AddPaymentView()
  
  private let addTransactionView = AddTransactionView()
  
  private let transactionButton = UIButton()
  private let addTransactionButton = UIButton()
  private let sendTransactionButton = UIButton()
  private let overlayView = UIView()
  
  private let settingsScreen = SettingsController()
  private let paymentsScreen = PaymentsScreenViewController(contentType: .listWithInteractiveCell)
  
  var categories: [Category] = []
  var payments: [Payment] = []
  
  private var state: DashboardState {
    didSet {
      switch state {
      case .normal:
        transactionButton.setTitle("T", for: .normal)
        addTransactionButton.isHidden = true
        sendTransactionButton.isHidden = true
        overlayView.isHidden = true
        addPaymentView.isHidden = true
        addCategoryView.isHidden = true
        addTransactionView.isHidden = true
        
        addCategoryView.setupInitialState()
        addPaymentView.setupInitialState()
        addTransactionView.setupInitialState()
      case .transactionButtonPressed:
        transactionButton.setTitle("X", for: .normal)
        overlayView.isHidden = false
        addTransactionButton.isHidden = false
        sendTransactionButton.isHidden = false
        addPaymentView.isHidden = true
        addCategoryView.isHidden = true
        addTransactionView.isHidden = true
      case .addPayment:
        transactionButton.setTitle("X", for: .normal)
        overlayView.isHidden = false
        addTransactionButton.isHidden = true
        sendTransactionButton.isHidden = true
        addPaymentView.isHidden = false
        addCategoryView.isHidden = true
        addTransactionView.isHidden = true
      case .addCategory:
        transactionButton.setTitle("X", for: .normal)
        overlayView.isHidden = false
        addTransactionButton.isHidden = true
        sendTransactionButton.isHidden = true
        addPaymentView.isHidden = true
        addCategoryView.isHidden = false
        addTransactionView.isHidden = true
      case .sendTransaction:
        transactionButton.setTitle("X", for: .normal)
        overlayView.isHidden = false
        addTransactionButton.isHidden = true
        sendTransactionButton.isHidden = true
        addPaymentView.isHidden = true
        addCategoryView.isHidden = true
        addTransactionView.isHidden = false
      case .getTransaction:
        transactionButton.setTitle("X", for: .normal)
        overlayView.isHidden = false
        addTransactionButton.isHidden = true
        sendTransactionButton.isHidden = true
        addPaymentView.isHidden = true
        addCategoryView.isHidden = true
        addTransactionView.isHidden = false
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
    
    settingsScreen.delegate = self
    settingsScreen.modalPresentationStyle = .fullScreen
    
    paymentsScreen.modalPresentationStyle = .fullScreen
    paymentsScreen.delegate = self
    
    setupSubviews()
    loadData()
  }
  
  override func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    super.setupColorTheme(colorTheme, theme)
  
    topBarView.setupColorTheme(colorTheme, theme)
    statsView.setupColorTheme(colorTheme, theme)
    categoriesView.setupColorTheme(colorTheme, theme)
    paymentsView.setupColorTheme(colorTheme, theme)
    lastTransactions.setupColorTheme(colorTheme, theme)
    
    addCategoryView.setupColorTheme(colorTheme, theme)
    addPaymentView.setupColorTheme(colorTheme, theme)
    
    transactionButton.backgroundColor = colorTheme.activeColor
    addTransactionButton.backgroundColor = colorTheme.activeColor
    sendTransactionButton.backgroundColor = colorTheme.activeColor
    
    addTransactionView.setupColorTheme(colorTheme, theme)
    settingsScreen.setupColorTheme(colorTheme, theme)
    paymentsScreen.setupColorTheme(colorTheme, theme)
  }
  
  private func loadData() {
    let dispatchGroup = DispatchGroup()
    
    dispatchGroup.enter()
    dataService.getAll(of: Payment.self, completion: BlockObject<[Payment], Void>({ payments in
      self.payments = payments
      dispatchGroup.leave()
    }))
    
    dispatchGroup.enter()
    dataService.getAll(of: Category.self, completion: BlockObject<[Category], Void>({ categories in
      self.categories = categories
      dispatchGroup.leave()
    }))
    
    dispatchGroup.enter()
    dataService.getAll(of: Transaction.self, completion: BlockObject<[Transaction], Void>({ transactions in
      dispatchGroup.leave()
    }))
    
    dispatchGroup.notify(queue: .main) {
      self.reloadData()
    }
  }
  
  private func reloadData() {
    DispatchQueue.main.async {
      self.categoriesView.setData(categories: self.categories)
      self.paymentsView.setData(payments: self.payments)
    }
  }
  
  @objc private func transactionButtonPressed() {
    switch state {
    case .normal:
      self.state = .transactionButtonPressed
    default:
      self.state = .normal
    }
  }
  
  @objc private func addTransactionButtonPressed() {
    addTransactionView.setTransactionType(.getMoney)
    self.state = .getTransaction
  }
  
  @objc private func sendTransactionButtonPressed() {
    addTransactionView.setTransactionType(.sendMoney)
    self.state = .sendTransaction
  }
  
}

extension DashboardViewController {
  private func setupSubviews() {
    let scrollContentView = UIView()
    
    //Under overlayView
    view.addSubview(mainScrollView)
    view.addSubview(topBarView)
    view.addSubview(overlayView)
    
    //Over overlayView
    view.addSubview(transactionButton)
    view.addSubview(addTransactionButton)
    view.addSubview(sendTransactionButton)
    view.addSubview(addPaymentView)
    view.addSubview(addCategoryView)
    view.addSubview(addTransactionView)
    
    mainScrollView.addSubview(scrollContentView)

    scrollContentView.addSubview(statsView)
    scrollContentView.addSubview(paymentsView)
    scrollContentView.addSubview(lastTransactions)
    scrollContentView.addSubview(categoriesView)
    
    topBarView.delegate = self
    paymentsView.delegate = self
    categoriesView.delegate = self
    lastTransactions.delegate = self
    addTransactionView.delegate = self
    
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
    addTransactionButton.setTitle("Add money", for: .normal)
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
    sendTransactionButton.setTitle("Spend money", for: .normal)
    sendTransactionButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
    sendTransactionButton.titleLabel?.textColor = .white
    sendTransactionButton.layer.borderColor = UIColor.white.cgColor
    
    addCategoryView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(188)
    }
    addCategoryView.delegate = self
    addCategoryView.isHidden = true
    
    addPaymentView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(496)
    }
    addPaymentView.delegate = self
    addPaymentView.isHidden = true
    
    addTransactionView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(42)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(340)
    }
    addTransactionView.isHidden = true
    
    mainScrollView.snp.makeConstraints { make in
      make.top.equalTo(topBarView.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
    
    scrollContentView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
      make.left.right.equalTo(view)
    }
    
    statsView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(DashboardConstants.StatsComponent.height)
    }
    
    paymentsView.snp.makeConstraints { make in
      make.top.equalTo(statsView.snp.bottom).offset(DashboardConstants.PaymentsComponent.topOffset)
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
      make.bottom.equalTo(scrollContentView.snp.bottom).offset(-92)
    }
  }
  
}

extension DashboardViewController: TopBarViewDelegate {
  func settingsButtonPressed() { present(settingsScreen, animated: true, completion: nil) }
}

extension DashboardViewController: PaymentsViewDelegate {
  func paymentPressed(for indexPath: IndexPath) { print(#line, #function, "Payment pressed with indexPath: \(indexPath)") }
  func showMorePaymentsPressed() {
    paymentsScreen.setData(payment: self.payments)
    present(paymentsScreen, animated: true, completion: nil)
    print(#line,#function,"Title pressed") }
  
  func addPaymentPressed(for indexPath: IndexPath) { self.state = .addPayment }
}

extension DashboardViewController: CategoriesViewDelegate {
  func categoryPressed(for indexPath: IndexPath) { print(#line, #function, "Category pressed with indexPath: \(indexPath)") }
  func showMoreCategoriesPressed() { print(#line,#function,"Title pressed") }
  
  func addCategoryPressed(for indexPath: IndexPath) { self.state = .addCategory }
}

extension DashboardViewController: LastTransactionsViewDelegate {
  func lastTransactionsPressed(for indexPath: IndexPath) { print("Transaction pressed at: \(indexPath.row)") }
  func showMoreLastTransactionsPressed() { print("Show more transactions pressed") }
}

extension DashboardViewController: AddPaymentViewDelegate {
  func addPayment(newPayment: Payment) {
    self.payments.append(newPayment)
    
    let comletionBlock = EmptyBlock { _ in
      DispatchQueue.main.async {
        self.paymentsView.setData(payments: self.payments)
      }
      self.state = .normal
    }
    
    dataService.addOrUpdate(object: newPayment, completion: comletionBlock)
  }
}

extension DashboardViewController: AddCategoryViewDelegate {
  func addCategory(newCategory: Category) {
    self.categories.append(newCategory)
    
    let comletionBlock = EmptyBlock { _ in
      DispatchQueue.main.async {
        self.categoriesView.setData(categories: self.categories)
      }
      self.state = .normal
    }
    
    dataService.addOrUpdate(object: newCategory, completion: comletionBlock)
  }
}

extension DashboardViewController: AddTransactionViewDelegate {
  func addTransactionSubmit() {
    print("Submit")
  }
  
  func addTransactionChoosePaymentPressed() {
    let paymentsController = PaymentsScreenViewController(contentType: .scrollingListForChoose)
    
    if let colorTheme = self.colorTheme,
       let theme = self.theme {
      paymentsController.setupColorTheme(colorTheme, theme)
    }
    
    paymentsController.setData(payment: self.payments)
    
    paymentsController.selectPaymentCompletion = { [weak self] payment in
      guard let self = self else { print("Error");return }
      self.addTransactionView.setPayment(payment: payment)
    }
    
    present(paymentsController, animated: true, completion: nil)
  }
  
  func addTransactionChooseCategoryPressed() {
    print("Category")
    let viewController = UIViewController()
    viewController.view.backgroundColor = .red
    present(viewController, animated: true, completion: nil)
  }
}

extension DashboardViewController: SettingsControllerDelegate {
  func settingsClearAllData() { print(#line,#function,"Clear all data") }
  func settingsChangeTheme(_ newTheme: ThemeType) { colorSchemeManager.currentTheme = newTheme }
}

extension DashboardViewController: PaymentsScreenViewControllerDelegate {
  
  func removePayment(for indexPath: IndexPath) {
    let payment = payments.remove(at: indexPath.row)
    dataService.remove(object: payment, completion: EmptyBlock({[weak self] _ in
      guard let self = self else { return }
      print("Item was removed at: \(indexPath.row)")
      DispatchQueue.main.async {
        self.paymentsView.setData(payments: self.payments)
      }
    }))
  }
  
  func addNewPayment(payment: Payment) {
    print(#line,#function,"Add new payment from payment screen")
    self.payments.append(payment)

    let comletionBlock = EmptyBlock { _ in
      DispatchQueue.main.async {
        self.paymentsView.setData(payments: self.payments)
        self.paymentsScreen.setData(payment: self.payments)
      }
    }

    dataService.addOrUpdate(object: payment, completion: comletionBlock)
  }
  
}

struct DashboardConstants {
  
  struct TopBar {
    static var height: CGFloat = UIScreen.main.bounds.height > 736 ? 120 : 100
  }
  
  struct StatsComponent {
    static var height: CGFloat = 400 //title with button 44 + 356
  }
  
  struct PaymentsComponent {
    static var height: CGFloat = 212 //title with button 36 + 176 collection
    static var topOffset: CGFloat = 20
  }
  
  struct LastTransactionsComponent {
    static var height: CGFloat = 396 //title with button 36 + 6 cells(every cell with 60 height with padding)
    static var topOffset: CGFloat = 20
  }
  
  struct CategoriesComponent {
    static var height: CGFloat = 124 //title with button 36 + 88 collection
    static var topOffset: CGFloat = 20
  }

}
