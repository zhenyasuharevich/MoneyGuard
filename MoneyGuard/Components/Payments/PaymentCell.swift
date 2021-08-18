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
  
  static func getCellType(for indexPath: IndexPath) -> PaymentCellType {
    if indexPath.row == 0 && indexPath.section == 0 {
      return .addPayment
    }
    return .payment
  }
}

final class PaymentCell: UICollectionViewCell {
  
  private let addPaymentLabel = UILabel()
  
  private var state: PaymentCellType = .payment {
    didSet {
      switch state {
      case .addPayment:
        addPaymentLabel.isHidden = false
      case .payment:
        addPaymentLabel.isHidden = true
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
  
}

extension PaymentCell {
  
  private func setupSubviews() {
    layer.cornerRadius = 20
    backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1529411765, blue: 0.2941176471, alpha: 1)
    
    contentView.addSubview(addPaymentLabel)
    
    addPaymentLabel.numberOfLines = 0
    addPaymentLabel.textAlignment = .center
    addPaymentLabel.textColor = .white
    addPaymentLabel.text = "+"
    addPaymentLabel.font = .systemFont(ofSize: 40, weight: .semibold)
    
    addPaymentLabel.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
  }
  
}
