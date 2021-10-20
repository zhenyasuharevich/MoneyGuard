//
//  AddCategoryCell.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 13/10/2021.
//

import UIKit

final class AddCategoryCell: UICollectionViewCell {
  
  private let addCategoryView = AddCategoryView()
  
  weak var delegate: AddCategoryViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
 
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    addCategoryView.setupColorTheme(colorTheme, theme)
  }
  
}

extension AddCategoryCell {
  private func setupSubviews() {
    self.contentView.addSubview(addCategoryView)
    
    addCategoryView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
    }
    addCategoryView.delegate = self
  }
}

extension AddCategoryCell: AddCategoryViewDelegate {
  func addCategory(newCategory: Category) {
    guard let delegate = delegate else { return }
    delegate.addCategory(newCategory: newCategory)
  }
}
