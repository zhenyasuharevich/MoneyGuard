//
//  UserDefaultsServiceLocator.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 06.05.2021.
//

import Foundation

protocol UserDefaultsServiceLocator {
    func userDefaults() -> UserDefaultsProtocol
}

extension UserDefaultsServiceLocator {
    func userDefaults() -> UserDefaultsProtocol {
        UserDefaults.standard
    }
}
