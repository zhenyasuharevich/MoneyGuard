//
//  CollectionViewCell.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 19/08/2021.
//

import UIKit

enum LastTransactionsCellType: Int {
  case transactions = 0
  case otherTransactions = 1
    
  static func getCellType(for indexPath: IndexPath, arrayCount: Int) -> LastTransactionsCellType {
    if indexPath.row == 5 && indexPath.section == 0 {
      return .otherTransactions
    }
    return .transactions
  }
}

final class LastTransactionsCell: UICollectionViewCell {
    
  private let otherTransactionsLabel = UILabel()
  
  private var state: LastTransactionsCellType = .transactions {
    didSet {
      switch state {
      case .otherTransactions:
        otherTransactionsLabel.isHidden = false
        otherTransactionsLabel.textAlignment = .center
      case .transactions:
        otherTransactionsLabel.isHidden = true
        otherTransactionsLabel.textAlignment = .left
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame);
    setupSubviews()
  }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func prepareForReuse() {
    self.state = .transactions
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    backgroundColor = colorTheme.cellBackgroundColor
    otherTransactionsLabel.textColor = colorTheme.textColor
  }
  
  func setState(state: LastTransactionsCellType) {
    self.state = state
  }
}

extension LastTransactionsCell {
  
  private func setupSubviews() {
    layer.cornerRadius = 20
    
    contentView.addSubview(otherTransactionsLabel)
    
    otherTransactionsLabel.numberOfLines = 0
    otherTransactionsLabel.textAlignment = .left
    otherTransactionsLabel.text = "See all transactions"
    otherTransactionsLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    
    otherTransactionsLabel.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
  }
  
}
