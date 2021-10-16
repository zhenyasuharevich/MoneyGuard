//
//  PaymentsScreenCell.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 26/09/2021.
//

import UIKit
import SwiftUI

protocol CellDelegate: AnyObject {
  func deleteButtonPressed(for indexPath: IndexPath)
}

enum PaymentScreenCellType: Int {
  case addPayment = 0
  case payment = 1
  
  static func getCellType(for indexPath: IndexPath) -> PaymentScreenCellType {
    if indexPath.section == 1 {
      return .addPayment
    }
    return .payment
  }
}

final class PaymentsScreenCell: UICollectionViewCell {
  
  private let cellView = UIView()
  private let deleteView = UIButton()
  private let deleteButton = UIButton()
  
  private let addPaymentLabel = UILabel()
  private let paymentNameLabel = UILabel()
  private let amountLabel = UILabel()
  private let amountValueLabel = UILabel()
  private let typeLabel = UILabel()
  private let typeValueLabel = UILabel()
  private let separatorView = UIView()
  
  weak var delegate: CellDelegate?
  var indexPath: IndexPath?
  var screenContentType: PaymentsViewControllerContentType?
  private var isAnimating: Bool = false
  
//  private var state: PaymentScreenCellType = .payment {
//    didSet {
//      switch state {
//      case .addPayment:
//        addPaymentLabel.isHidden = false
//        paymentNameLabel.isHidden = true
//        amountLabel.isHidden = true
//        amountValueLabel.isHidden = true
//        typeLabel.isHidden = true
//        typeValueLabel.isHidden = true
//        separatorView.isHidden = true
//
//      case .payment:
//        addPaymentLabel.isHidden = true
//        paymentNameLabel.isHidden = false
//        amountLabel.isHidden = false
//        amountValueLabel.isHidden = false
//        typeLabel.isHidden = false
//        typeValueLabel.isHidden = false
//        separatorView.isHidden = false
//      }
//    }
//  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
    setupGestures()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func prepareForReuse() {
    
    self.indexPath = nil
    self.screenContentType = nil
    self.delegate = nil
    self.isAnimating = false
    
    self.cellView.snp.updateConstraints { (make) in
      make.trailing.equalToSuperview()
    }
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    deleteView.backgroundColor = colorTheme.activeColor
    deleteButton.setTitleColor(colorTheme.cellBackgroundColor, for: .normal)
    cellView.backgroundColor = colorTheme.cellBackgroundColor
    addPaymentLabel.textColor = colorTheme.textColor
    backgroundColor = colorTheme.cellBackgroundColor
    
    paymentNameLabel.textColor = colorTheme.textColor
    amountLabel.textColor = colorTheme.textColor.withAlphaComponent(0.6)
    amountValueLabel.textColor = colorTheme.textColor.withAlphaComponent(0.8)
    typeLabel.textColor = colorTheme.textColor.withAlphaComponent(0.6)
    typeValueLabel.textColor = colorTheme.textColor.withAlphaComponent(0.8)
    
    separatorView.backgroundColor = colorTheme.activeColor
  }
  
  func setupData(indexPath: IndexPath, payment: Payment, screenContentType: PaymentsViewControllerContentType) {
    self.paymentNameLabel.text = payment.name
    self.amountValueLabel.text = "\(payment.amount)"
    self.typeValueLabel.text = payment.type.rawValue
    
    self.indexPath = indexPath
    self.screenContentType = screenContentType
  }
  
  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case .right:
        animateRight()
      case .left:
        animateLeft()
      default:
        break
      }
    }
  }
  
  @objc func deleteButtonPressed() {
    guard let indexPath = self.indexPath,
          let delegate = self.delegate else { return }
    
    delegate.deleteButtonPressed(for: indexPath)
  }
  
  private func animateLeft() {
    guard let contentType = self.screenContentType,
          !(contentType == .scrollingListForChoose) else { return }
    guard !self.isAnimating else { return }
    
    self.isAnimating = true
    
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
      self.cellView.snp.updateConstraints { (make) in
        make.trailing.equalToSuperview().offset(-36)
      }
      self.layoutIfNeeded()
    } completion: { completed in
      if completed {
        print("Swiped left")
        self.isAnimating = false
      }
    }
  }
  
  private func animateRight() {
    guard let contentType = self.screenContentType,
          !(contentType == .scrollingListForChoose) else { return }
    guard !self.isAnimating else { return }
    
    self.isAnimating = true
    
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
      self.cellView.snp.updateConstraints { (make) in
        make.trailing.equalToSuperview()
      }
      self.layoutIfNeeded()
    } completion: { completed in
      if completed {
        print("Swiped right")
        self.isAnimating = false
      }
    }
  }
  
}

extension PaymentsScreenCell {
  
  private func setupSubviews() {
    layer.cornerRadius = 20
    
    contentView.addSubview(deleteView)
    deleteView.addSubview(deleteButton)
    contentView.addSubview(cellView)
    cellView.addSubview(addPaymentLabel)
    cellView.addSubview(paymentNameLabel)
    cellView.addSubview(amountLabel)
    cellView.addSubview(amountValueLabel)
    cellView.addSubview(typeLabel)
    cellView.addSubview(typeValueLabel)
    cellView.addSubview(separatorView)
    
    deleteView.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
    
    deleteView.layer.masksToBounds = false
    deleteView.layer.cornerRadius = 20
    
    deleteButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(0)
      make.top.bottom.equalToSuperview()
      make.width.equalTo(36)
    }
    deleteButton.backgroundColor = .clear
    deleteButton.setTitle("x", for: .normal)
    deleteButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
    
    cellView.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalToSuperview()
    }
    
    cellView.layer.cornerRadius = 20
    cellView.layer.masksToBounds = false
    
//    addPaymentLabel.numberOfLines = 0
//    addPaymentLabel.textAlignment = .center
//    addPaymentLabel.text = "+"
//    addPaymentLabel.font = .systemFont(ofSize: 36, weight: .semibold)
//
//    addPaymentLabel.snp.makeConstraints { make in
//      make.leading.trailing.bottom.top.equalToSuperview()
//    }
    
    paymentNameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(4)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      //make.height.equalTo(24)
    }
    paymentNameLabel.numberOfLines = 0
    paymentNameLabel.textAlignment = .center
    paymentNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
    paymentNameLabel.adjustsFontSizeToFitWidth = true
    paymentNameLabel.minimumScaleFactor = 0.8
    
    separatorView.snp.makeConstraints { make in
      make.top.equalTo(paymentNameLabel.snp.bottom).offset(4)
      make.trailing.equalToSuperview().offset(-20)
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(1)
    }
    
    amountLabel.snp.makeConstraints { make in
      make.top.equalTo(paymentNameLabel.snp.bottom).offset(8)
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(20)
    }
    amountLabel.textAlignment = .left
    amountLabel.font = .systemFont(ofSize: 16, weight: .regular)
    amountLabel.text = "Amount:"
    
    amountValueLabel.snp.makeConstraints { make in
      make.top.equalTo(paymentNameLabel.snp.bottom).offset(8)
      make.leading.equalTo(amountLabel.snp.trailing).offset(8)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(20)
    }
    amountValueLabel.textAlignment = .right
    amountValueLabel.font = .systemFont(ofSize: 16, weight: .medium)
    amountValueLabel.adjustsFontSizeToFitWidth = true
    amountValueLabel.minimumScaleFactor = 0.8
    
    typeLabel.snp.makeConstraints { make in
      make.top.equalTo(amountLabel.snp.bottom).offset(4)
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(20)
    }
    typeLabel.textAlignment = .left
    typeLabel.font = .systemFont(ofSize: 16, weight: .regular)
    typeLabel.text = "Type:"
    
    typeValueLabel.snp.makeConstraints { make in
      make.top.equalTo(amountLabel.snp.bottom).offset(4)
      make.leading.equalTo(typeLabel.snp.trailing).offset(8)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(20)
    }
    typeValueLabel.textAlignment = .right
    typeValueLabel.font = .systemFont(ofSize: 16, weight: .medium)
  }
  
  private func setupGestures() {
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
    swipeLeft.direction = .left
    self.addGestureRecognizer(swipeLeft)
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
    swipeRight.direction = .right
    self.addGestureRecognizer(swipeRight)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteButtonPressed))
    self.deleteButton.addGestureRecognizer(tapGesture)
  }
  
}
