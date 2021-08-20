//
//  ColorSchemeManager.swift
//  onestat
//
//  Created by Zhenya Suharevich on 06.05.2021.
//

import UIKit

typealias ColorThemeBlock = ((_ theme: ColorThemeProtocol, _ type: ThemeType) -> Void)?

protocol ColorSchemeManagerProtocol {
  var currentTheme: ThemeType { get set }
  func subscribeUpdate(identificator: String, updateHandler: ColorThemeBlock)
  func unsubscribe(identificator: String)
}

final class ColorSchemeManager: ColorSchemeManagerProtocol {
  static let shared = ColorSchemeManager()
  
  typealias ServiceLocatorAlias = UserDefaultsServiceLocator
  final class ServiceLocator: ServiceLocatorAlias {}
  
  private let themeKey = "themeKey"
  
  var currentTheme: ThemeType {
    didSet {
      userDefaults.set(currentTheme, themeKey)
      colorTheme = ColorThemeFactory.create(currentTheme)
    }
  }
  
  private var colorTheme: ColorThemeProtocol {
    didSet {
      subscribers.forEach { $0.value?(colorTheme, currentTheme) }
    }
  }
  
  private let userDefaults: UserDefaultsProtocol
  
  private var subscribers: [String: ColorThemeBlock] = [:]
  
  init(serviceLocator: ServiceLocatorAlias = ServiceLocator()) {
    userDefaults = serviceLocator.userDefaults()
    currentTheme = userDefaults.getValue(forKey: themeKey) ?? .system
    colorTheme = ColorThemeFactory.create(currentTheme)
  }
  
  func subscribeUpdate(identificator: String, updateHandler: ColorThemeBlock) {
    subscribers[identificator] = updateHandler
    updateHandler?(colorTheme, currentTheme)
  }
  
  func unsubscribe(identificator: String) {
    subscribers.removeValue(forKey: identificator)
  }
  
}


