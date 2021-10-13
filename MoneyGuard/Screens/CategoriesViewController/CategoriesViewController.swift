//
//  CategoriesViewController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 19/09/2021.
//

import UIKit

protocol CategoriesViewControllerDelegate: AnyObject {
  func categoryPressed(for indexPath: IndexPath)
  func addCategoryPressed(for indexPath: IndexPath)
}

enum CategoriesViewControllerContentType {
  case scrollingListForChoose
  case listWithInteractiveCell
}

final class CategoriesViewController: UIViewController {
  
  private let topBar = UIView()
  private let returnButton = UIButton()
  private let screenNameLabel = UILabel()
  
//  private let addCategoryView = AddCategoryView()
  private let overlayView = UIView()
  
  lazy var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(CategoriesScreenCell.self, forCellWithReuseIdentifier: CategoriesScreenCell.reuseIdentifier)
    cv.register(AddCategoryCell.self, forCellWithReuseIdentifier: AddCategoryCell.reuseIdentifier)
    cv.dataSource = self
    cv.delegate = self
    cv.showsVerticalScrollIndicator = false
    cv.contentInset = UIEdgeInsets(top: 16,
                                   left: 8,
                                   bottom: UIScreen.main.bounds.height - DashboardConstants.TopBar.height - 188,
                                   right: 8)
    return cv
  }()
  
  weak var delegate: CategoriesViewControllerDelegate?

  var categories = [
    Category(identifier: UUID().uuidString, name: "TRANSPORT", amountSpent: 500),
    Category(identifier: UUID().uuidString, name: "MEAL", amountSpent: 1000),
    Category(identifier: UUID().uuidString, name: "HOUSE", amountSpent: 550),
    Category(identifier: UUID().uuidString, name: "PLEASURE", amountSpent: 1000),
    Category(identifier: UUID().uuidString, name: "TELEPHONE", amountSpent: 50),
    Category(identifier: UUID().uuidString, name: "AAAAAA", amountSpent: 50),
    Category(identifier: UUID().uuidString, name: "BBBBB", amountSpent: 50),
    Category(identifier: UUID().uuidString, name: "CCCCC", amountSpent: 510),
    Category(identifier: UUID().uuidString, name: "DDDDD", amountSpent: 2510),
    Category(identifier: UUID().uuidString, name: "EEEEE", amountSpent: 10),
    Category(identifier: UUID().uuidString, name: "FFFFF", amountSpent: 60),
    Category(identifier: UUID().uuidString, name: "GGGG", amountSpent: 90),
    Category(identifier: UUID().uuidString, name: "HHHHH", amountSpent: 52)
  ]
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  private var contentType: CategoriesViewControllerContentType

  init(contentType: CategoriesViewControllerContentType) {
      self.contentType = contentType
      super.init(nibName: nil, bundle: nil)
    }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSubview()
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    
    topBar.backgroundColor = colorTheme.formBackgroundColor
    view.backgroundColor = colorTheme.backgroundColor
    returnButton.setTitleColor(colorTheme.textColor, for: .normal)
    screenNameLabel.textColor = colorTheme.textColor
//    addCategoryView.setupColorTheme(colorTheme, theme)
    collectionView.reloadData()
  }
  
  @objc private func returnButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
  
}

extension CategoriesViewController : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return categories.count
    } else if section == 1 {
      return 1
    }
    
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellType = CategoriesScreenCellType.getCellType(for: indexPath)
    switch cellType {
    case .category:
      
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesScreenCell.reuseIdentifier, for: indexPath) as? CategoriesScreenCell else { print(#line,#function,"Error: Can't get CategoriesCell");
        return UICollectionViewCell() }
      
      let category = categories[indexPath.row]
      cell.setupData(indexPath: indexPath, category: category, screenContentType: self.contentType)
      cell.delegate = self
      
      if let colorTheme = self.currentColorTheme,
         let theme = self.currentTheme {
        cell.setupColorTheme(colorTheme, theme)
      }
      
      return cell
      
    case .addCategory:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCategoryCell.reuseIdentifier, for: indexPath) as? AddCategoryCell else { print(#line,#function,"Error: Can't get CategoriesCell");
        return UICollectionViewCell() }
      print("Add category cell")
      if let colorTheme = self.currentColorTheme,
         let theme = self.currentTheme {
        cell.setupColorTheme(colorTheme, theme)
      }
      
      return cell
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard contentType == .listWithInteractiveCell else { return  1}
    return 2
  }
   
}

extension CategoriesViewController : UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard !(self.contentType == .listWithInteractiveCell) else { return }
    print("Select item at indexPath.row: \(indexPath.row)")
  }

}

extension CategoriesViewController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellType = CategoriesScreenCellType.getCellType(for: indexPath)
    switch cellType {
    case .addCategory:
      let widthCell = collectionView.frame.width - 16
      let height: CGFloat = 188
      return CGSize(width: widthCell, height: height)
    case .category:
      let widthCell = collectionView.frame.width / 2 - 16
      let heightCell = (collectionView.frame.height - (5 * 4))/5
      return CGSize(width: widthCell, height: heightCell)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 16 }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 8 }
}

extension CategoriesViewController {
  private func setupSubview() {
    view.backgroundColor = .clear
    view.addSubview(topBar)
    topBar.addSubview(returnButton)
    topBar.addSubview(screenNameLabel)
    view.addSubview(collectionView)
//    view.addSubview(addCategoryView)
    view.addSubview(overlayView)
    
    topBar.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(DashboardConstants.TopBar.height)
    }
    
    topBar.layer.cornerRadius = 20
    topBar.layer.masksToBounds = true
    topBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    
    returnButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-28)
      make.leading.equalToSuperview().offset(28)
      make.height.equalTo(24)
      make.width.equalTo(24)
    }
    
    returnButton.setTitle("←", for: .normal)
    returnButton.addTarget(self, action: #selector(returnButtonPressed), for: .touchUpInside)
    returnButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
    
    screenNameLabel.snp.makeConstraints { make in
      make.centerY.equalTo(returnButton)
      make.centerX.equalToSuperview()
    }
    
    screenNameLabel.font = .systemFont(ofSize: 20, weight: .medium)
    screenNameLabel.text = "All categories"
    
//    addCategoryView.snp.makeConstraints { make in
//      make.top.equalToSuperview().offset(30)
//      make.trailing.equalToSuperview().offset(-16)
//      make.leading.equalToSuperview().offset(16)
//      make.height.equalTo(188)
//    }
    
//    addCategoryView.delegate = self
//    addCategoryView.isHidden = true
    
    overlayView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    overlayView.isHidden = true
    overlayView.backgroundColor = .black
    overlayView.alpha = 0.7
    
    collectionView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().offset(-8)
      make.bottom.equalToSuperview()
      make.top.equalTo(topBar.snp.bottom)
    }
    
    collectionView.backgroundColor = .clear
  }
  
}

extension CategoriesViewController: CategoriesCellDelegate {
  func deleteButtonPressed(for indexPath: IndexPath) {
    let alert = UIAlertController(title: "Are you sure you want to delete this category?", message: nil, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
      guard let self = self else { return }
      
      self.categories.remove(at: indexPath.row)
      
      self.collectionView.performBatchUpdates {
        self.collectionView.deleteItems(at: [indexPath])
      } completion: { completed in
        if completed {
          self.collectionView.reloadData()
        }
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
      guard let self = self else { return }
      self.collectionView.reloadItems(at: [indexPath])
    }
    
    
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
}


//extension CategoriesViewController: AddCategoryViewDelegate {
//  func addCategory(newCategory: Category) {
//    self.categories.append(newCategory)
//
//    let comletionBlock = EmptyBlock { _ in
//      DispatchQueue.main.async {
//        self.categoriesView.setData(categories: self.categories)
//      }
//      self.state = .normal
//    }
//
//    dataService.addOrUpdate(object: newCategory, completion: comletionBlock)
//  }
//}


