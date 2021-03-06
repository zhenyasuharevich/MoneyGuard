//
//  PaymentsView.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 10.08.2021.
//

import UIKit

protocol PaymentsViewDelegate: AnyObject {
  func paymentPressed(for indexPath: IndexPath)
  func addPaymentPressed(for indexPath: IndexPath)
  func showMorePaymentsPressed()
}

final class PaymentsView: UIView {
  
  private let titleLabel = UILabel()
  private let disclosureIndicatorImageView = UIImageView()
  private let mainActiveButton = UIButton()
  
  weak var delegate: PaymentsViewDelegate?
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  private var payments: [Payment] = []
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.register(PaymentCell.self, forCellWithReuseIdentifier: PaymentCell.reuseIdentifier)
    collection.dataSource = self
    collection.delegate = self
    collection.showsHorizontalScrollIndicator = false
    collection.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    return collection
  }()
  
  init() {
    super.init(frame: .zero)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func setData(payments: [Payment]) {
    self.payments = payments
    
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
  @objc private func titlePressed() {
    delegate?.showMorePaymentsPressed()
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    titleLabel.textColor = colorTheme.textColor
    disclosureIndicatorImageView.tintColor = colorTheme.textColor
    
    collectionView.reloadData()
  }
  
}

extension PaymentsView: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if payments.count < 5 {
      return payments.count + 1
    } else {
      return 6
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCell.reuseIdentifier, for: indexPath) as? PaymentCell else { print(#line,#function,"Error: Can't get PaymentCell"); return UICollectionViewCell() }
    let cellType = PaymentCellType.getCellType(for: indexPath, arrayCount: payments.count)
    cell.setState(state: cellType)
    
    switch cellType {
    case .payment:
      let payment = payments[indexPath.row]
      cell.setData(payment: payment)
    case .addPayment:
      break
    }
    
    if let colorTheme = self.currentColorTheme,
       let theme = self.currentTheme {
      cell.setupColorTheme(colorTheme, theme)
    }
    
    return cell
  }
}

extension PaymentsView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cellType = PaymentCellType.getCellType(for: indexPath, arrayCount: payments.count)
    
    switch cellType {
    case .addPayment:
      delegate?.addPaymentPressed(for: indexPath)
    case .payment:
      delegate?.paymentPressed(for: indexPath)
    }
  }
}

extension PaymentsView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 200, height: collectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 10 }
}

extension PaymentsView {
  
  private func setupSubviews() {
    backgroundColor = .clear
    
    addSubview(titleLabel)
    addSubview(disclosureIndicatorImageView)
    addSubview(mainActiveButton)
    addSubview(collectionView)
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalToSuperview()
      make.trailing.equalTo(disclosureIndicatorImageView.snp.leading).offset(-8)
      make.height.equalTo(28)
    }
    titleLabel.text = "Payments"
    titleLabel.textAlignment = .left
    
    disclosureIndicatorImageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-16)
      
      make.height.equalTo(20)
      make.width.equalTo(20)
      make.centerY.equalTo(titleLabel)
    }
    let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
    disclosureIndicatorImageView.image = image
    disclosureIndicatorImageView.contentMode = .scaleAspectFit
    
    mainActiveButton.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
      make.height.equalTo(36)
    }
    
    mainActiveButton.addTarget(self, action: #selector(titlePressed), for: .touchUpInside)
    
    collectionView.snp.remakeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(mainActiveButton.snp.bottom)
    }
    
    collectionView.backgroundColor = .clear
  }
  
}
