//
//  CategoriesCell.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 23/08/2021.
//

import UIKit

enum CategoriesCellType: Int {
  case addCategory = 0
  case category = 1
  
  static func getCellType(for indexPath: IndexPath) -> CategoriesCellType {
    if indexPath.row == 0 && indexPath.section == 0 {
      return .addCategory
    }
    return .category
  }
}

final class CategoriesCell: UICollectionViewCell {
  
  private let  addCategoryLabel = UILabel()
  
  private var state: CategoriesCellType = .category {
    didSet {
      switch state {
      case .addCategory:
        addCategoryLabel.isHidden = false
      case .category:
        addCategoryLabel.isHidden = true
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.state = .category
  }
  
  func setState(state: CategoriesCellType) {
    self.state = state
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    addCategoryLabel.textColor = colorTheme.textColor
    backgroundColor = colorTheme.cellBackgroundColor
  }
  
}

extension CategoriesCell {
  private func setupSubviews() {
    layer.cornerRadius = 20
    
    contentView.addSubview(addCategoryLabel)
    
    addCategoryLabel.numberOfLines = 0
    addCategoryLabel.textAlignment = .center
    addCategoryLabel.text = "+"
    addCategoryLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    
    addCategoryLabel.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
  }
  
}
