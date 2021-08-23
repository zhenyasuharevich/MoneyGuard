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
  
  private let transactionsTitle = UILabel()
  private let disclosureIndicatorImageView = UIImageView()
  private let transactionsButton = UIButton()
  
  weak var delegate: LastTransactionsViewDelegate?
  
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
  
  @objc func buttonAction(_ sender: UIButton ) { delegate?.showMoreLastTransactionsPressed() }
  
}

extension LastTransactionsView : UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 6 }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastTransactionsCell.reuseIdentifier, for: indexPath) as? LastTransactionsCell else { print(#line,#function,"Error: Can't get LastTransactionsCell"); return UICollectionViewCell() }
    let cellType = LastTransactionsCellType.getCellType(for: indexPath)
    cell.setState(state: cellType)
    return cell
  }
  
}

extension LastTransactionsView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cellType = LastTransactionsCellType.getCellType(for: indexPath)
    
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
    
    addSubview(transactionsTitle)
    addSubview(disclosureIndicatorImageView)
    addSubview(transactionsButton)
    addSubview(collectionView)

    transactionsTitle.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalToSuperview()
      make.trailing.equalTo(disclosureIndicatorImageView.snp.leading).offset(-8)
      make.height.equalTo(28)
    }
    
    transactionsTitle.text = "Last transactions"
    transactionsTitle.textColor = .white
    transactionsTitle.textAlignment = .left
    
    disclosureIndicatorImageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalToSuperview()
      make.height.width.equalTo(28)
    }
    
    disclosureIndicatorImageView.backgroundColor = .red
    
    transactionsButton.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
      make.height.equalTo(36)
    }
    
    transactionsButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(transactionsButton.snp.bottom)
    }
    
    collectionView.backgroundColor = .clear
  }
  
}
