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
    
  static func getCellType(for indexPath: IndexPath) -> LastTransactionsCellType {
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
      case .transactions:
        otherTransactionsLabel.isHidden = true
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
  
  func setState(state: LastTransactionsCellType) {
    self.state = state
  }
}

extension LastTransactionsCell {
  
  private func setupSubviews() {
    layer.cornerRadius = 20
    backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1529411765, blue: 0.2941176471, alpha: 1)
    
    contentView.addSubview(otherTransactionsLabel)
    
    otherTransactionsLabel.numberOfLines = 0
    otherTransactionsLabel.textAlignment = .center
    otherTransactionsLabel.textColor = .white
    otherTransactionsLabel.text = "See all transactions"
    otherTransactionsLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    
    otherTransactionsLabel.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
  }
  
}
