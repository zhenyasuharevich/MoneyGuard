//
//  PaymentCell.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 10.08.2021.
//

import UIKit

enum PaymentCellType: Int {
  case addPayment = 0
  case payment = 1
  
  static func getCellType(for indexPath: IndexPath, arrayCount: Int) -> PaymentCellType {
    if (indexPath.row == 5 || indexPath.row == arrayCount) && indexPath.section == 0 {
      return .addPayment
    }
    return .payment
  }
}

final class PaymentCell: UICollectionViewCell {
  
  private let addPaymentLabel = UILabel()
  private let paymentNameLabel = UILabel()
  private let amountLabel = UILabel()
  private let amountValueLabel = UILabel()
  private let typeLabel = UILabel()
  private let typeValueLabel = UILabel()
  private let separatorView = UIView()
  
  private var state: PaymentCellType = .payment {
    didSet {
      switch state {
      case .addPayment:
        addPaymentLabel.isHidden = false
        paymentNameLabel.isHidden = true
        amountLabel.isHidden = true
        amountValueLabel.isHidden = true
        typeLabel.isHidden = true
        typeValueLabel.isHidden = true
        separatorView.isHidden = true
      case .payment:
        addPaymentLabel.isHidden = true
        paymentNameLabel.isHidden = false
        amountLabel.isHidden = false
        amountValueLabel.isHidden = false
        typeLabel.isHidden = false
        typeValueLabel.isHidden = false
        separatorView.isHidden = false
      }
    }
  }
  
  override init(frame: CGRect) { super.init(frame: frame); setupSubviews() }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func prepareForReuse() {
    self.state = .payment
  }
  
  func setState(state: PaymentCellType) {
    self.state = state
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    addPaymentLabel.textColor = colorTheme.textColor
    backgroundColor = colorTheme.cellBackgroundColor
    
    paymentNameLabel.textColor = colorTheme.textColor
    amountLabel.textColor = colorTheme.textColor.withAlphaComponent(0.6)
    amountValueLabel.textColor = colorTheme.textColor.withAlphaComponent(0.8)
    typeLabel.textColor = colorTheme.textColor.withAlphaComponent(0.6)
    typeValueLabel.textColor = colorTheme.textColor.withAlphaComponent(0.8)
    
    separatorView.backgroundColor = colorTheme.activeColor
  }
  
  func setData(payment: Payment) {
    self.paymentNameLabel.text = payment.name
    self.amountValueLabel.text = "\(payment.amount)"
    self.typeValueLabel.text = payment.type.rawValue
  }
  
}

extension PaymentCell {
  
  private func setupSubviews() {
    layer.cornerRadius = 20
    
    contentView.addSubview(addPaymentLabel)
    contentView.addSubview(paymentNameLabel)
    contentView.addSubview(amountLabel)
    contentView.addSubview(amountValueLabel)
    contentView.addSubview(typeLabel)
    contentView.addSubview(typeValueLabel)
    contentView.addSubview(separatorView)
    
    addPaymentLabel.numberOfLines = 0
    addPaymentLabel.textAlignment = .center
    addPaymentLabel.text = "+"
    addPaymentLabel.font = .systemFont(ofSize: 40, weight: .semibold)
    
    addPaymentLabel.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
    
    paymentNameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(72)
    }
    paymentNameLabel.numberOfLines = 0
    paymentNameLabel.textAlignment = .center
    paymentNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
    paymentNameLabel.adjustsFontSizeToFitWidth = true
    paymentNameLabel.minimumScaleFactor = 0.8
    
    separatorView.snp.makeConstraints { make in
      make.top.equalTo(paymentNameLabel.snp.bottom)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(1)
    }
    
    amountLabel.snp.makeConstraints { make in
      make.top.equalTo(paymentNameLabel.snp.bottom).offset(12)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(24)
    }
    amountLabel.textAlignment = .left
    amountLabel.font = .systemFont(ofSize: 16, weight: .regular)
    amountLabel.text = "Amount:"
    
    amountValueLabel.snp.makeConstraints { make in
      make.top.equalTo(paymentNameLabel.snp.bottom).offset(12)
      make.leading.equalTo(amountLabel.snp.trailing).offset(8)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(24)
    }
    amountValueLabel.textAlignment = .right
    amountValueLabel.font = .systemFont(ofSize: 16, weight: .medium)
    amountValueLabel.adjustsFontSizeToFitWidth = true
    amountValueLabel.minimumScaleFactor = 0.8
    
    typeLabel.snp.makeConstraints { make in
      make.top.equalTo(amountLabel.snp.bottom).offset(12)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(24)
    }
    typeLabel.textAlignment = .left
    typeLabel.font = .systemFont(ofSize: 16, weight: .regular)
    typeLabel.text = "Type:"
    
    typeValueLabel.snp.makeConstraints { make in
      make.top.equalTo(amountLabel.snp.bottom).offset(12)
      make.leading.equalTo(typeLabel.snp.trailing).offset(8)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(24)
    }
    typeValueLabel.textAlignment = .right
    typeValueLabel.font = .systemFont(ofSize: 16, weight: .medium)
  }
  
}
