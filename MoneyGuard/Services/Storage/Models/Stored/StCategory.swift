//
//  StCategory.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 23.08.2021.
//

import Foundation


class StCategory: Object {
  @objc dynamic var identifier: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var amountSpent: Double = 0
  
  convenience init(identifier: String, name: String, amountSpent: Double) {
    self.init()
    self.identifier = identifier
    self.name = name
    self.amountSpent = amountSpent
  }
  
  public override class func primaryKey() -> String? {
    "identifier"
  }
}

extension StCategory: StorableProtocol {
  func createRuntimeModel() -> RunTimeModelProtocol {
    Category(identifier: self.identifier,
             name: self.name,
             amountSpent: self.amountSpent)
  }
  
  func getIdentifier() -> String { return self.identifier }
}
