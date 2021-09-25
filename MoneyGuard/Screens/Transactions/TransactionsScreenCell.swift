//
//  TransactionsScreenCell.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 25/09/2021.
//

import UIKit

final class TransactionsScreenCell: UICollectionViewCell {
    
  override init(frame: CGRect) {
    super.init(frame: frame);
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    backgroundColor = colorTheme.cellBackgroundColor
  }
  
}

extension TransactionsScreenCell {
  private func setupSubviews() {
    layer.cornerRadius = 20
    
//    backgroundColor = .red
  }
  
  
  
}
