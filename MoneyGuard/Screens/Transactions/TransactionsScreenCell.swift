//
//  TransactionsScreenCell.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 25/09/2021.
//

import UIKit

final class TransactionsScreenCell: UICollectionViewCell {
  
  let imageViewTransaction = UIImageView()
  private let dataLabel = UILabel()
  var fromLabel = UILabel()
  private let paymentView = UIView()
  let paymentNameLabel = UILabel()
  let toLabel = UILabel()
  private let categoryView = UIView()
  let categoryNameLabel = UILabel()
  private let separatorView = UIView()
  var signLabel = UILabel()
  private let transactionAmountLabel = UILabel()
  private let amountLabel = UILabel()
  
  lazy var formatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    backgroundColor = colorTheme.cellBackgroundColor
    
    dataLabel.textColor = colorTheme.textColor
    transactionAmountLabel.textColor = colorTheme.textColor
    paymentNameLabel.textColor = colorTheme.textColor
    fromLabel.textColor = colorTheme.textColor
    paymentNameLabel.textColor = colorTheme.textColor
    toLabel.textColor = colorTheme.textColor
    categoryNameLabel.textColor = colorTheme.textColor
    signLabel.textColor = colorTheme.textColor
    separatorView.backgroundColor = colorTheme.activeColor
  }
  
  func setData(transaction: Transaction) {
    self.signLabel.text = "\(transaction.type)"
    self.dataLabel.text = formatter.string(from: transaction.date)
    self.paymentNameLabel.text = transaction.paymentName
    self.categoryNameLabel.text = transaction.categoryName
  }
  
}

extension TransactionsScreenCell {
  private func setupSubviews() {
    layer.cornerRadius = 20
    
    contentView.addSubview(imageViewTransaction)
    contentView.addSubview(dataLabel)
    
    contentView.addSubview(paymentView)
    paymentView.addSubview(fromLabel)
    paymentView.addSubview(paymentNameLabel)
    
    contentView.addSubview(categoryView)
    categoryView.addSubview(toLabel)
    categoryView.addSubview(categoryNameLabel)

    contentView.addSubview(separatorView)
    contentView.addSubview(amountLabel)
    contentView.addSubview(transactionAmountLabel)
    contentView.addSubview(signLabel)
    
    imageViewTransaction.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(16)
      make.width.equalTo(16)
    }
    
    dataLabel.snp.makeConstraints{ make in
      make.centerY.equalTo(imageViewTransaction)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(16)
      
    }
    
    dataLabel.textAlignment = .right
    dataLabel.font = .systemFont(ofSize: 16, weight: .regular)
    dataLabel.text = "14.10.2021"
    
    paymentView.snp.makeConstraints { make in
      make.top.equalTo(imageViewTransaction.snp.bottom).offset(16)
      make.leading.equalTo(imageViewTransaction.snp.trailing)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    fromLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
      make.width.equalTo(44)
    }
    
    fromLabel.font = .systemFont(ofSize: 16, weight: .regular)
    fromLabel.text = "From: "

    paymentNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(fromLabel.snp.trailing).offset(4)
      make.centerY.equalToSuperview()
    }
    
    paymentNameLabel.font = .systemFont(ofSize: 24, weight: .semibold)
    paymentNameLabel.text = "Payment"
    
    categoryView.snp.makeConstraints { make in
      make.top.equalTo(paymentView.snp.bottom).offset(24)
      make.leading.equalTo(imageViewTransaction.snp.trailing)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    toLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
      make.width.equalTo(44)
    }
    
    toLabel.font = .systemFont(ofSize: 16, weight: .regular)
    toLabel.text = "To: "
    
    categoryNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(toLabel.snp.trailing).offset(4)
      make.centerY.equalToSuperview()
    }

    categoryNameLabel.font = .systemFont(ofSize: 20, weight: .regular)
    categoryNameLabel.text = "Category"
    
    separatorView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalTo(categoryView.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(1)
    }
    
    amountLabel.snp.makeConstraints{ make in
      make.top.equalTo(separatorView.snp.bottom).offset(8)
      make.trailing.equalTo(signLabel.snp.leading).offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(20)
    }
    
    amountLabel.textAlignment = .left
    amountLabel.font = .systemFont(ofSize: 16, weight: .regular)
    amountLabel.text = "Amount: "

    transactionAmountLabel.snp.makeConstraints{ make in
      make.top.equalTo(separatorView.snp.bottom).offset(8)
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
  }

}
