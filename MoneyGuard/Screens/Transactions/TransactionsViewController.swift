//
//  TransactionsViewController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 25/09/2021.
//

import UIKit

protocol TransactionsViewControllerDelegate: AnyObject {
  func addTransactionChoosePaymentPressed()
  func addTransactionChooseCategoryPressed()
}

class TransactionsViewController: UIViewController {
  
  private let topBar = UIView()
  private let returnButton = UIButton()
  private let screenNameLabel = UILabel()
  
  lazy var collectionView : UICollectionView = {
     let layout = UICollectionViewFlowLayout()
     layout.scrollDirection = .vertical
     
     let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
     cv.register(TransactionsScreenCell.self, forCellWithReuseIdentifier: TransactionsScreenCell.reuseIdentifier)
     cv.translatesAutoresizingMaskIntoConstraints = false
     cv.dataSource = self
     cv.delegate = self
     cv.showsVerticalScrollIndicator = false
     cv.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    return cv
   }()
  

  
  weak var delegate: TransactionsViewControllerDelegate?
  
  private var transactions: [Transaction] = []
  
  private var currentTheme: ThemeType?
  private var currentColorTheme: ColorThemeProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
  }

  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    
    topBar.backgroundColor = colorTheme.formBackgroundColor
    view.backgroundColor = colorTheme.backgroundColor
    returnButton.setTitleColor(colorTheme.textColor, for: .normal)
    screenNameLabel.textColor = colorTheme.textColor
    
    collectionView.reloadData()
  }
  
  @objc private func returnButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func setData(transactions: [Transaction]) {
    self.transactions = transactions
    collectionView.reloadData()
  }
  
}

extension TransactionsViewController : UICollectionViewDelegate {

}

extension TransactionsViewController : UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { transactions.count }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionsScreenCell.reuseIdentifier, for: indexPath) as? TransactionsScreenCell else {
      print(#line,#function,"Error: Can't get LastTransactionsCell"); return UICollectionViewCell()
    }
    
    let transaction = transactions[indexPath.row]
    cell.setData(transaction: transaction)
    
    
    if transaction.type == .sendMoney {
      cell.signLabel.text = "-"
      cell.fromLabel.text = "From:"
      cell.categoryNameLabel.isHidden = false
      cell.toLabel.isHidden = false
      cell.imageViewTransaction.backgroundColor = .red
    } else {
      cell.signLabel.text = "+"
      cell.fromLabel.text = "To:"
      cell.categoryNameLabel.isHidden = true
      cell.toLabel.isHidden = true
      cell.imageViewTransaction.backgroundColor = .green
    }
    
    if let colorTheme = self.currentColorTheme,
       let theme = self.currentTheme {
      cell.setupColorTheme(colorTheme, theme)
    }
    
    return cell
  }
  
}

extension TransactionsViewController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let widthCell = collectionView.frame.width - 32
    return CGSize(width: widthCell, height: (collectionView.frame.height - (5 * 4))/3.5)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 8 }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 8 }
}

extension TransactionsViewController {
  private func setupSubviews() {
    
    view.addSubview(topBar)
    topBar.addSubview(returnButton)
    topBar.addSubview(screenNameLabel)
    view.addSubview(collectionView)
    
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
    screenNameLabel.text = "All transactions"
    
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(topBar.snp.bottom)
    }
    
    collectionView.backgroundColor = .clear
  }
  
}
