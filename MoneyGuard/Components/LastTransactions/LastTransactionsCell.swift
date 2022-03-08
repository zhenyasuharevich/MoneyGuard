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
    
    if (indexPath.row == 5 || indexPath.row == arrayCount) && indexPath.section == 0 {
      return .otherTransactions
    }
    return .transactions
  }
}

final class LastTransactionsCell: UICollectionViewCell {
  
  private let otherTransactionsLabel = UILabel()
  
  let imageViewTransaction = UIImageView()
  private let fromToView = UIView()
  var fromToLabel = UILabel()
  private let paymentView = UIView()
  let paymentNameLabel = UILabel()
  
  var signLabel = UILabel()
  let transactionAmountLabel = UILabel()
  
  private var state: LastTransactionsCellType = .transactions {
    didSet {
      switch state {
      case .otherTransactions:
        otherTransactionsLabel.isHidden = false
        signLabel.isHidden = true
        fromToLabel.isHidden = true
        paymentNameLabel.isHidden = true
        imageViewTransaction.isHidden = true
        transactionAmountLabel.isHidden = true
        otherTransactionsLabel.textAlignment = .center
      case .transactions:
        signLabel.isHidden = false
        fromToLabel.isHidden = false
        paymentNameLabel.isHidden = false
        imageViewTransaction.isHidden = false
        transactionAmountLabel.isHidden = false
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
    
    fromToLabel.textColor = colorTheme.textColor
    paymentNameLabel.textColor = colorTheme.textColor
    
    signLabel.textColor = colorTheme.textColor
    transactionAmountLabel.textColor = colorTheme.textColor
  }
  
  func setData(transaction: Transaction) {
    self.signLabel.text = "\(transaction.type)"
    self.paymentNameLabel.text = transaction.paymentName
    self.transactionAmountLabel.text = "\(transaction.amount)"
  }
  
  func setState(state: LastTransactionsCellType) {
    self.state = state
  }
}

extension LastTransactionsCell {
  
  private func setupSubviews() {
    layer.cornerRadius = 20
    
    contentView.addSubview(imageViewTransaction)
    contentView.addSubview(fromToView)
    fromToView.addSubview(fromToLabel)
    contentView.addSubview(paymentView)
    paymentView.addSubview(paymentNameLabel)
    contentView.addSubview(signLabel)
    contentView.addSubview(transactionAmountLabel)
    
    contentView.addSubview(otherTransactionsLabel)
    
    imageViewTransaction.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(16)
      make.width.equalTo(16)
    }
    
    imageViewTransaction.backgroundColor = .green
    
    let heightView = frame.height / 2
    
    fromToView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(imageViewTransaction.snp.trailing).offset(16)
      make.width.equalTo(44)
      make.height.equalTo(20)
    }
    
    fromToLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalToSuperview().offset(4)
      make.width.equalTo(44)
    }
    
    fromToLabel.font = .systemFont(ofSize: 16, weight: .light)
    fromToLabel.text = "From: "
    
    paymentView.snp.makeConstraints { make in
      make.top.equalTo(fromToView.snp.bottom).offset(4)
      make.leading.equalTo(imageViewTransaction.snp.trailing).offset(16)
      make.height.equalTo(heightView)
    }
    
    paymentNameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalToSuperview()
      make.width.equalTo(UIScreen.main.bounds.width - 144)
    }
    
    paymentNameLabel.font = .systemFont(ofSize: 20, weight: .regular)
    paymentNameLabel.text = "Payment"
  
    
    transactionAmountLabel.snp.makeConstraints{ make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(20)
    }
    
    transactionAmountLabel.textAlignment = .right
    transactionAmountLabel.font = .systemFont(ofSize: 20, weight: .regular)
    transactionAmountLabel.text = "50000"

    signLabel.snp.makeConstraints { make in
      make.trailing.equalTo(transactionAmountLabel.snp.leading).offset(-4)
      make.centerY.equalTo(transactionAmountLabel)
    }
    
    signLabel.text = "+"
    signLabel.textAlignment = .right
    signLabel.font = .systemFont(ofSize: 20, weight: .regular)
    
    otherTransactionsLabel.numberOfLines = 0
    otherTransactionsLabel.textAlignment = .left
    otherTransactionsLabel.text = "See all transactions"
    otherTransactionsLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    
    otherTransactionsLabel.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
  }
  
}
