//
//  RealmServiceLoacator.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 23.08.2021.
//

import Foundation

public protocol RealmServiceLocator {
    func databaseService() -> RealmServiceProtocol
}

public extension RealmServiceLocator {
    func databaseService() -> RealmServiceProtocol {
      RealmService.shared
    }
}
