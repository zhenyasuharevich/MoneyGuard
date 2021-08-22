//
//  BaseController.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 20.08.2021.
//

import UIKit

class BaseController: UIViewController {
  typealias ServiceLocatorAlias = ColorSchemeManagerLocator
  final class ServiceLocator: ServiceLocatorAlias {}
  
  var colorSchemeManager: ColorSchemeManagerProtocol
  
  init(serviceLocator: ServiceLocator = ServiceLocator()) {
    self.colorSchemeManager = serviceLocator.colorThemeManager()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupColorThemeSubscriber()
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