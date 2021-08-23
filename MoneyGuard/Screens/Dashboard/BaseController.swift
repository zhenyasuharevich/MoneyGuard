//
//  BaseController.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 20.08.2021.
//

import UIKit

class BaseController: UIViewController {
  typealias ThemeLocatorAlias = ColorSchemeManagerLocator
  typealias StorageLocatorAlias = RealmServiceLocator
  final class ServiceLocator: ThemeLocatorAlias, StorageLocatorAlias {}
  
  var colorSchemeManager: ColorSchemeManagerProtocol
  let dataService: RealmServiceProtocol
  
  init(serviceLocator: ServiceLocator = ServiceLocator()) {
    self.colorSchemeManager = serviceLocator.colorThemeManager()
    self.dataService = serviceLocator.databaseService()
    self.dataService.setup(version: 0)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupColorThemeSubscriber()
    loadData()
  }
  
  private func loadData() {
    let dispatchGroup = DispatchGroup()
    
    dispatchGroup.enter()
    dataService.getAll(of: Payment.self, completion: BlockObject<[Payment], Void>({ payments in
      print("Payments loaded")
      print("Payments count: \(payments.count)")
      for payment in payments {
        print("Name: \(payment.name), amount: \(payment.amount)")
      }
      dispatchGroup.leave()
    }))
    
    dispatchGroup.enter()
    dataService.getAll(of: Category.self, completion: BlockObject<[Category], Void>({ categories in
      print("Categories loaded")
      print("Categories count: \(categories.count)")
      for category in categories {
        print("Name: \(category.name), amountSpent: \(category.amountSpent)")
      }
      dispatchGroup.leave()
    }))
    
    dispatchGroup.enter()
    dataService.getAll(of: Transaction.self, completion: BlockObject<[Transaction], Void>({ transactions in
      print("Transactions loaded")
      print("Transactions count: \(transactions.count)")
      for transaction in transactions {
        print("Date: \(transaction.date), type: \(transaction.type)")
      }
      dispatchGroup.leave()
    }))
    
    dispatchGroup.notify(queue: .main) {
      print("Data loading finished")
    }
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    view.backgroundColor = colorTheme.backgroundColor
  }
  
  func setupColorThemeSubscriber() {
    colorSchemeManager.subscribeUpdate(identificator: String(describing: self), updateHandler: setupColorTheme(_:_:))
  }
  
  func changeColorTheme(with themeType: ThemeType) {
    self.colorSchemeManager.currentTheme = themeType
  }
}
