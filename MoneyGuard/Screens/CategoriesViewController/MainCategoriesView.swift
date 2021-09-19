//
//  MainCategoriesView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 19/09/2021.
//

import UIKit

protocol MainCategoriesViewDelegate: AnyObject {
  func categoryPressed(for indexPath: IndexPath)
  func addCategoryPressed(for indexPath: IndexPath)
}

class MainCategoriesView: UIView {
  
  weak var delegate: MainCategoriesViewDelegate?
  
  private let categoriesTitleLabel = UILabel()
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  private var categories: [Category] = []
  
  lazy var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(MainCategoriesCell.self, forCellWithReuseIdentifier: MainCategoriesCell.reuseIdentifier)
    cv.dataSource = self
    cv.delegate = self
    cv.showsHorizontalScrollIndicator = false
    cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    return cv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    categoriesTitleLabel.textColor = colorTheme.textColor
    
    collectionView.reloadData()
  }
  
  func setData(categories: [Category]) {
    self.categories = categories
    
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }

}

extension MainCategoriesView : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    if categories.count < 5 {
//      return categories.count + 1
//    } else {
//      return 6
//    }
    categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCategoriesCell.reuseIdentifier, for: indexPath) as? MainCategoriesCell else { print(#line,#function,"Error: Can't get CategoriesCell");
      return UICollectionViewCell() }
    
    let cellType = MainCategoriesCellType.getCellType(for: indexPath, arrayCount: categories.count)
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

extension MainCategoriesView : UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cellType = MainCategoriesCellType.getCellType(for: indexPath, arrayCount: categories.count)
    
    switch cellType {
    case .addCategory:
      delegate?.addCategoryPressed(for: indexPath)
    case .category:
      delegate?.categoryPressed(for: indexPath)
    }
  }
  
}

extension MainCategoriesView : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 88)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 10 }
}

extension MainCategoriesView {
  private func setupSubviews() {
    backgroundColor = .clear
    categoriesTitleLabel.text = "All categories"
    categoriesTitleLabel.textAlignment = .center
    
    addSubview(categoriesTitleLabel)
    addSubview(collectionView)
    
    categoriesTitleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalToSuperview()
      make.height.equalTo(38)
    }
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(categoriesTitleLabel.snp.bottom).offset(0)
      make.trailing.leading.equalToSuperview()
    }
    
    collectionView.backgroundColor = .clear
  }
}
