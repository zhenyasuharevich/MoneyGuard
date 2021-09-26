//
//  CategoriesScreenCell.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 19/09/2021.
//

import UIKit

enum CategoriesScreenCellType: Int {
  case addCategory = 0
  case category = 1
  
  static func getCellType(for indexPath: IndexPath, arrayCount: Int) -> CategoriesScreenCellType {
    if indexPath.row == arrayCount && indexPath.section == 0 {
      return .addCategory
    }
    return .category
  }
}

final class CategoriesScreenCell: UICollectionViewCell {
  
  private let cellView = UIView()
  private let deleteView = UIButton()
  private let deleteButton = UIButton()
  private let addCategoryLabel = UILabel()
  private let categoryNameLabel = UILabel()
  private let amountSpentLabel = UILabel()
  private let separatorView = UIView()
  
  private var state: CategoriesScreenCellType = .category {
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
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
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
  
  func setState(state: CategoriesScreenCellType) {
    self.state = state
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    deleteView.backgroundColor = colorTheme.activeColor
    deleteButton.setTitleColor(colorTheme.cellBackgroundColor, for: .normal)
    cellView.backgroundColor = colorTheme.cellBackgroundColor
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
  
  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case .right:
        print("Swiped right")
        animateRight()
      case .left:
        print("Swiped left")
        animateLeft()
      default:
        break
      }
    }
  }
  
  @objc func deleteButtonPressed() {
    print("deleteButtonPressed")
  }
  
}

extension CategoriesScreenCell {
  private func setupSubviews() {
    layer.cornerRadius = 20
    
    contentView.addSubview(deleteView)
    deleteView.addSubview(deleteButton)
    contentView.addSubview(cellView)
    cellView.addSubview(addCategoryLabel)
    cellView.addSubview(categoryNameLabel)
    cellView.addSubview(amountSpentLabel)
    cellView.addSubview(separatorView)
    
    deleteView.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
    
    deleteView.layer.masksToBounds = false
    deleteView.layer.cornerRadius = 20
    
    deleteButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalToSuperview()
      make.width.equalTo(36)
    }
    deleteButton.backgroundColor = .clear
    deleteButton.setTitle("x", for: .normal)
    deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    deleteButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
    
    cellView.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
    
    cellView.layer.cornerRadius = 20
    cellView.layer.masksToBounds = false
    
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
    categoryNameLabel.text = "Transport"
    
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
  
  func animateLeft() {
    UIView.animate(withDuration: 5) {
      self.cellView.snp.updateConstraints { (make) in
        make.trailing.equalToSuperview().offset(-36)
      }
    }
    self.layoutIfNeeded()
  }
  
  func animateRight() {
    UIView.animate(withDuration: 5) {
      self.cellView.snp.updateConstraints { (make) in
        make.trailing.equalToSuperview()
      }
    }
    self.layoutIfNeeded()
  }
  
}
