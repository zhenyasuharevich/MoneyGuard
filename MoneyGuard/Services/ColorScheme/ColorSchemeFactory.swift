//
//  ColorSchemeFactory.swift
//  onestat
//
//  Created by Zhenya Suharevich on 06.05.2021.
//

import UIKit

protocol ColorThemeFactoryProtocol {
  static func create(_ theme: ThemeType) -> ColorThemeProtocol
}

final class ColorThemeFactory: ColorThemeFactoryProtocol {
  static func create(_ theme: ThemeType) -> ColorThemeProtocol {
    switch theme {
    case .dark:
      return DarkColorTheme()
    case .light:
      return LightColorTheme()
    case .system:
      switch UIScreen.main.traitCollection.userInterfaceStyle {
      case .dark:
          return DarkColorTheme()
      case .light, .unspecified:
          return LightColorTheme()
      @unknown default:
          return LightColorTheme()
      }
    }
  }
}
