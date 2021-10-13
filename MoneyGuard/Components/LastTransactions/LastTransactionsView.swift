//
//  LastTransactions.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 19/08/2021.
//

import UIKit

protocol LastTransactionsViewDelegate: AnyObject {
  func lastTransactionsPressed(for indexPath: IndexPath)
  func showMoreLastTransactionsPressed()
}

final class LastTransactionsView: UIView {
  
  private let transactionsTitleLabel = UILabel()
  private let disclosureIndicatorImageView = UIImageView()
  private let mainActiveButton = UIButton()
  
  weak var delegate: LastTransactionsViewDelegate?
  
  private var transactions = [
    Transaction(identifier: UUID().uuidString, type: .getMoney, date: .distantPast, paymentName: "Millenium", categoryName: "Meal", description: "Testujem"),
    Transaction(identifier: UUID().uuidString, type: .getMoney, date: .distantPast, paymentName: "Millenium", categoryName: "Meal", description: "Testujem"),
    Transaction(identifier: UUID().uuidString, type: .getMoney, date: .distantPast, paymentName: "Millenium", categoryName: "Meal", description: "Testujem"),
    Transaction(identifier: UUID().uuidString, type: .getMoney, date: .distantPast, paymentName: "Millenium", categoryName: "Meal", description: "Testujem"),
    Transaction(identifier: UUID().uuidString, type: .getMoney, date: .distantPast, paymentName: "Millenium", categoryName: "Meal", description: "Testujem"),
    Transaction(identifier: UUID().uuidString, type: .getMoney, date: .distantPast, paymentName: "Millenium", categoryName: "Meal", description: "Testujem"),
    Transaction(identifier: UUID().uuidString, type: .getMoney, date: .distantPast, paymentName: "Millenium", categoryName: "Meal", description: "Testujem"),
    Transaction(identifier: UUID().uuidString, type: .getMoney, date: .distantPast, paymentName: "Millenium", categoryName: "Meal", description: "Testujem")
  ]
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  lazy var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.register(LastTransactionsCell.self, forCellWithReuseIdentifier: LastTransactionsCell.reuseIdentifier)
    cv.dataSource = self
    cv.delegate = self
    cv.showsVerticalScrollIndicator = false
    cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    cv.isScrollEnabled = false
    
    return cv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupSubViews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    disclosureIndicatorImageView.tintColor = colorTheme.textColor
    transactionsTitleLabel.textColor = colorTheme.textColor
    
    collectionView.reloadData()
  }
  
  @objc func titlePressed(_ sender: UIButton ) { delegate?.showMoreLastTransactionsPressed() }
  
}

extension LastTransactionsView : UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 6 }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastTransactionsCell.reuseIdentifier, for: indexPath) as? LastTransactionsCell else { print(#line,#function,"Error: Can't get LastTransactionsCell"); return UICollectionViewCell() }
    let cellType = LastTransactionsCellType.getCellType(for: indexPath, arrayCount: 10)
    
    if let colorTheme = self.currentColorTheme,
       let theme = self.currentTheme {
      cell.setupColorTheme(colorTheme, theme)
    }
    
    cell.setState(state: cellType)
    
    return cell
  }
  
}

extension LastTransactionsView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cellType = LastTransactionsCellType.getCellType(for: indexPath, arrayCount: 10)
    
    switch cellType {
    case .otherTransactions:
      delegate?.showMoreLastTransactionsPressed()
    case .transactions:
      delegate?.lastTransactionsPressed(for: indexPath)
    }
  }
}

extension LastTransactionsView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let widthCell = collectionView.frame.width - 32
    return CGSize(width: widthCell, height: (collectionView.frame.height - (5 * 4))/6)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 4 }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 4 }
}

extension LastTransactionsView {
  private func setupSubViews() {
    
    addSubview(transactionsTitleLabel)
    addSubview(disclosureIndicatorImageView)
    addSubview(mainActiveButton)
    addSubview(collectionView)

    transactionsTitleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalToSuperview()
      make.trailing.equalTo(disclosureIndicatorImageView.snp.leading).offset(-8)
      make.height.equalTo(28)
    }
    
    transactionsTitleLabel.text = "Last transactions"
    transactionsTitleLabel.textAlignment = .left
    
    disclosureIndicatorImageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(20)
      make.width.equalTo(20)
      make.centerY.equalTo(transactionsTitleLabel)
    }
    let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
    disclosureIndicatorImageView.image = image
    disclosureIndicatorImageView.contentMode = .scaleAspectFit
    
    mainActiveButton.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
      make.height.equalTo(36)
    }
    
    mainActiveButton.addTarget(self, action: #selector(titlePressed), for: .touchUpInside)
    
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(mainActiveButton.snp.bottom)
    }
    
    collectionView.backgroundColor = .clear
  }
  
}
