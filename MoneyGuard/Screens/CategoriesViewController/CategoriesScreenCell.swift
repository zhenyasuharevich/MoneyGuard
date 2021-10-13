//
//  CategoriesScreenCell.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 19/09/2021.
//

import UIKit

protocol CategoriesCellDelegate: AnyObject {
  func deleteButtonPressed(for IndexPath: IndexPath)
}

enum CategoriesScreenCellType: Int {
  case addCategory = 0
  case category = 1
  
  static func getCellType(for indexPath: IndexPath) -> CategoriesScreenCellType {
    if indexPath.section == 1 {
      return .addCategory
    }
    return .category
  }
}

final class CategoriesScreenCell: UICollectionViewCell {
  
  private let cellView = UIView()
  private let deleteView = UIButton()
  private let deleteButton = UIButton()
  private let categoryNameLabel = UILabel()
  private let amountSpentLabel = UILabel()
  private let separatorView = UIView()
  
  weak var delegate: CategoriesCellDelegate?
  var indexPath: IndexPath?
  var screenContentType: CategoriesViewControllerContentType?
  var isAnimating: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupSubviews()
    setupGestures()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    
    self.indexPath = nil
    self.screenContentType = nil
    self.delegate = nil
    self.isAnimating = false
    
    self.cellView.snp.updateConstraints { (make) in
      make.trailing.equalToSuperview()
    }
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    deleteView.backgroundColor = colorTheme.activeColor
    deleteButton.setTitleColor(colorTheme.cellBackgroundColor, for: .normal)
    cellView.backgroundColor = colorTheme.cellBackgroundColor
    categoryNameLabel.textColor = colorTheme.textColor
    amountSpentLabel.textColor = colorTheme.textColor
    separatorView.backgroundColor = colorTheme.activeColor
    backgroundColor = colorTheme.cellBackgroundColor
  }
  
  func setupData(indexPath: IndexPath, category: Category, screenContentType: CategoriesViewControllerContentType) {
    categoryNameLabel.text = category.name
    amountSpentLabel.text = "\(category.amountSpent)"
    
    self.indexPath = indexPath
    self.screenContentType = screenContentType
  }
  
  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case .right:
        animateRight()
      case .left:
        animateLeft()
      default:
        break
      }
    }
  }
  
  @objc func deleteButtonPressed() {
    guard let indexPath = indexPath,
    let delegate = self.delegate else { return }
    
    delegate.deleteButtonPressed(for: indexPath)
  }
  
  private func animateLeft() {
    guard let contentType = self.screenContentType,
          !(contentType == .scrollingListForChoose) else { return }
    guard !self.isAnimating else { return }
    
    self.isAnimating = true
    
    UIView.animate(withDuration: 0.2,delay: 0, options: .curveEaseIn) {
      self.cellView.snp.updateConstraints { (make) in
        make.trailing.equalToSuperview().offset(-36)
      }
      self.layoutIfNeeded()
    } completion: { completed in
      if completed {
        print("Swiped left")
        self.isAnimating = false
      }
    }
  }
  
  private func animateRight() {
    guard let contentType = self.screenContentType,
          !(contentType == .scrollingListForChoose) else { return }
    guard !self.isAnimating else { return }
    
    self.isAnimating = true
    
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
      self.cellView.snp.updateConstraints { (make) in
        make.trailing.equalToSuperview()
      }
      self.layoutIfNeeded()
    } completion: { completed in
      if completed {
        print("Swiped right")
        self.isAnimating = false
      }
    }
  }
  
}


extension CategoriesScreenCell {
  private func setupSubviews() {
    layer.cornerRadius = 20
    
    contentView.addSubview(deleteView)
    deleteView.addSubview(deleteButton)
    contentView.addSubview(cellView)
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
  
  private func setupGestures() {
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
    swipeLeft.direction = .left
    self.addGestureRecognizer(swipeLeft)
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
    swipeRight.direction = .right
    self.addGestureRecognizer(swipeRight)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteButtonPressed))
    self.deleteButton.addGestureRecognizer(tapGesture)
  }
  
}
