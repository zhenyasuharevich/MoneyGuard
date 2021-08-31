//
//  CategoriesView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 23/08/2021.
//

import UIKit
import SnapKit

protocol CategoriesViewDelegate: AnyObject {
  func categoryPressed(for indexPath: IndexPath)
  func addCategoryPressed(for indexPath: IndexPath)
  func showMoreCategoriesPressed()
}

final class CategoriesView: UIView {
  
  private let categoriesTitleLabel = UILabel()
  private let disclosureIndicatorImageView = UIImageView()
  private let mainActiveButton = UIButton()
  
  weak var delegate: CategoriesViewDelegate?
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  private var categories: [Category] = []
  
  lazy var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(CategoriesCell.self, forCellWithReuseIdentifier: CategoriesCell.reuseIdentifier)
    cv.dataSource = self
    cv.delegate = self
    cv.showsHorizontalScrollIndicator = false
    cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    return cv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setubSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func titlePressed() {
    delegate?.showMoreCategoriesPressed()
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    categoriesTitleLabel.textColor = colorTheme.textColor
    disclosureIndicatorImageView.tintColor = colorTheme.textColor
    
    collectionView.reloadData()
  }
  
  func setData(categories: [Category]) {
    self.categories = categories
    
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
}

extension CategoriesView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if categories.count < 5 {
      return categories.count + 1
    } else {
      return 6
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCell.reuseIdentifier, for: indexPath) as? CategoriesCell else { print(#line,#function,"Error: Can't get CategoriesCell"); return UICollectionViewCell() }
    
    let cellType = CategoriesCellType.getCellType(for: indexPath, arrayCount: categories.count)
    cell.setState(state: cellType)
    if let colorTheme = self.currentColorTheme,
       let theme = self.currentTheme {
      cell.setupColorTheme(colorTheme, theme)
    }
    
    switch cellType {
    case .category:
      let category = categories[indexPath.row]
      cell.setData(category: category)
    case .addCategory:
      break
    }
    
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
  
}

extension CategoriesView : UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cellType = CategoriesCellType.getCellType(for: indexPath, arrayCount: categories.count)
    
    switch cellType {
    case .addCategory:
      delegate?.addCategoryPressed(for: indexPath)
    case .category:
      delegate?.categoryPressed(for: indexPath)
    }
  }
  
}

extension CategoriesView : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 88, height: collectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 10 }
  
}

extension CategoriesView {
  
  private func setubSubviews() {
    backgroundColor = .clear
    
    addSubview(categoriesTitleLabel)
    addSubview(disclosureIndicatorImageView)
    addSubview(mainActiveButton)
    addSubview(collectionView)
    
    categoriesTitleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalToSuperview()
      make.trailing.equalTo(disclosureIndicatorImageView.snp.leading).offset(-8)
      make.height.equalTo(28)
    }
    
    categoriesTitleLabel.text = "Categories"
    categoriesTitleLabel.textAlignment = .left
    
    disclosureIndicatorImageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(20)
      make.width.equalTo(20)
      make.centerY.equalTo(categoriesTitleLabel)
    }
    let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
    disclosureIndicatorImageView.image = image
    disclosureIndicatorImageView.contentMode = .scaleAspectFit
    
    mainActiveButton.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
      make.height.equalTo(36)
    }
    
    mainActiveButton.addTarget(self, action: #selector(titlePressed), for: .touchUpInside)
    
    collectionView.snp.remakeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(mainActiveButton.snp.bottom)
    }
    
    collectionView.backgroundColor = .clear
  }
  
}

