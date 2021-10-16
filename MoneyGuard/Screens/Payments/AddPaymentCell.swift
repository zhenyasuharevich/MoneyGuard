//
//  AddPaymentCell.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 15/10/2021.
//

import UIKit

class AddPaymentCell: UICollectionViewCell {
  
  private let addPaymentView = AddPaymentView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
 
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    addPaymentView.setupColorTheme(colorTheme, theme)
  }
  
}

extension AddPaymentCell {
  private func setupSubviews() {
    self.contentView.addSubview(addPaymentView)
    
    addPaymentView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
    }
  }
}
