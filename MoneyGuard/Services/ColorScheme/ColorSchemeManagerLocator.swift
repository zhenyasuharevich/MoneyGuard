//
//  ColorThemeManagerLocator.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 06.05.2021.
//

import Foundation

protocol ColorSchemeManagerLocator {
    func colorThemeManager() -> ColorSchemeManagerProtocol
}

extension ColorSchemeManagerLocator {
    func colorThemeManager() -> ColorSchemeManagerProtocol {
        ColorSchemeManager.shared
    }
}
