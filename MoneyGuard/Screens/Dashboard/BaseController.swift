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
    
//    dataService.getAll(of: Payment.self, completion: BlockObject<[Payment], Void>({ payments in
//      print("Payments loaded")
//      print("Payments count: \(payments.count)")
//      for payment in payments {
//        print("Name: \(payment.name), amount: \(payment.amount)")
//      }
//    }))
//
//    let payment = Payment(identifier: UUID().uuidString, name: "TestPayment", amount: 1200, type: .card)
//
//    let completionBlock = EmptyBlock {
//      print("Payment with name: \(payment.name) was added succesfully")
//    }
//
//    dataService.addOrUpdate(object: payment, completion: completionBlock)
    
//    dataService.getAll(of: Category.self, completion: BlockObject<[Category], Void>({ categories in
//      print("Categories loaded")
//      print("Categories count: \(categories.count)")
//      for category in categories {
//        print("Name: \(category.name), amountSpent: \(category.amountSpent)")
//      }
//    }))
//
//    let category = Category(identifier: UUID().uuidString, name: "TestCategory", amountSpent: 500)
//
//    let completionBlock = EmptyBlock {
//      print("Payment with name: \(category.name) was added succesfully")
//    }
//
//    dataService.addOrUpdate(object: category, completion: completionBlock)
    
//    dataService.getAll(of: GetTransaction.self, completion: BlockObject<[GetTransaction], Void>({ transactions in
//      print("Get Transactions loaded")
//      print("Get Transactions count: \(transactions.count)")
//      for getTransaction in transactions {
//        print("Date: \(getTransaction.date)")
//      }
//    }))

//    let getTransaction = GetTransaction(identifier: UUID().uuidString, date: Date(), paymentName: "TestPayment")
//
//    let completionBlock3 = EmptyBlock {
//      print("get transaction was added succesfully")
//    }
//
//    dataService.addOrUpdate(object: getTransaction, completion: completionBlock3)
    
//    dataService.getAll(of: SendTransaction.self, completion: BlockObject<[SendTransaction], Void>({ transactions in
//      print("Send Transactions loaded")
//      print("Send Transactions count: \(transactions.count)")
//      for getTransaction in transactions {
//        print("Date: \(getTransaction.date)")
//      }
//    }))

//    let spendTransaction = SendTransaction(identifier: UUID().uuidString, date: Date(), paymentName: "TestPayment", categoryName: "TestCategory")
//
//    let completionBlock4 = EmptyBlock {
//      print("send transaction was added succesfully")
//    }
//
//    dataService.addOrUpdate(object: spendTransaction, completion: completionBlock4)
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
