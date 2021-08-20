//
//  UICollectionViewCell+Extension.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 10.08.2021.
//

import UIKit

public extension UICollectionReusableView {
  static var reuseIdentifier: String { return String(describing: self) }
}
