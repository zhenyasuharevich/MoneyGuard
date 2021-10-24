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
  
  var colorTheme: ColorThemeProtocol?
  var theme: ThemeType?
  
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
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.colorTheme = colorTheme
    self.theme = theme
    view.backgroundColor = colorTheme.backgroundColor
  }
  
  func setupColorThemeSubscriber() {
    colorSchemeManager.subscribeUpdate(identificator: String(describing: self), updateHandler: setupColorTheme(_:_:))
  }
  
  func changeColorTheme(with themeType: ThemeType) {
    self.colorSchemeManager.currentTheme = themeType
  }
}
