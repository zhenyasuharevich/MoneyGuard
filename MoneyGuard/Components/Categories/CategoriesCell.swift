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
  
  static func getCellType(for indexPath: IndexPath, arrayCount: Int) -> CategoriesCellType {
    if (indexPath.row == 5 || indexPath.row == arrayCount) && indexPath.section == 0 {
      return .addCategory
    }
    return .category
  }
}

final class CategoriesCell: UICollectionViewCell {
  
  private let addCategoryLabel = UILabel()
  private let categoryNameLabel = UILabel()
  private let amountSpentLabel = UILabel()
  private let separatorView = UIView()
  
  private var state: CategoriesCellType = .category {
    didSet {
      switch state {
      case .addCategory:
        addCategoryLabel.isHidden = false
        categoryNameLabel.isHidden = true
        amountSpentLabel.isHidden = true
        separatorView.isHidden = true
      case .category:
        addCategoryLabel.isHidden = true
        categoryNameLabel.isHidden = false
        amountSpentLabel.isHidden = false
        separatorView.isHidden = false
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
    categoryNameLabel.textColor = colorTheme.textColor
    amountSpentLabel.textColor = colorTheme.textColor
    separatorView.backgroundColor = colorTheme.activeColor
    backgroundColor = colorTheme.cellBackgroundColor
  }
  
  func setData(category: Category) {
    categoryNameLabel.text = category.name
    amountSpentLabel.text = "\(category.amountSpent)"
  }
  
}

extension CategoriesCell {
  private func setupSubviews() {
    layer.cornerRadius = 20
    
    contentView.addSubview(addCategoryLabel)
    contentView.addSubview(categoryNameLabel)
    contentView.addSubview(amountSpentLabel)
    contentView.addSubview(separatorView)
    
    addCategoryLabel.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
    addCategoryLabel.numberOfLines = 0
    addCategoryLabel.textAlignment = .center
    addCategoryLabel.text = "+"
    addCategoryLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    
    categoryNameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(4)
      make.trailing.equalToSuperview().offset(-4)
      make.bottom.equalToSuperview().offset(-4)
      make.height.equalTo(36)
    }
    categoryNameLabel.numberOfLines = 0
    categoryNameLabel.textAlignment = .center
    categoryNameLabel.font = .systemFont(ofSize: 12, weight: .light)
    categoryNameLabel.text = "Transport Transport"
    
    amountSpentLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(4)
      make.trailing.equalToSuperview().offset(-4)
      make.top.equalToSuperview().offset(4)
      make.bottom.equalTo(categoryNameLabel.snp.top).offset(-4)
    }
    amountSpentLabel.numberOfLines = 1
    amountSpentLabel.textAlignment = .center
    amountSpentLabel.font = .systemFont(ofSize: 20, weight: .regular)
    amountSpentLabel.text = "19250"
    amountSpentLabel.adjustsFontSizeToFitWidth = true
    amountSpentLabel.minimumScaleFactor = 0.8
    
    separatorView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(4)
      make.trailing.equalToSuperview().offset(-4)
      make.height.equalTo(1)
      make.bottom.equalTo(categoryNameLabel.snp.top)
    }
  }
  
}
