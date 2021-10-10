//
//  PaymentsScreenViewController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 26/09/2021.
//

import UIKit

protocol PaymentsScreenViewControllerDelegate: AnyObject {
  func paymentPressed(for indexPath: IndexPath)
  func addPaymentPressed(for indexPath: IndexPath)
}

enum PaymentsViewControllerState {
  case normal
  case transactionButtonPressed
  case addPayment
}

final class PaymentsScreenViewController: UIViewController {
  
  private let topBar = UIView()
  private let returnButton = UIButton()
  private let screenNameLabel = UILabel()
  
  private let addPaymentView = AddPaymentView()
  private let overlayView = UIView()
  
  lazy var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(PaymentsScreenCell.self, forCellWithReuseIdentifier: PaymentsScreenCell.reuseIdentifier)
    cv.delegate = self
    cv.dataSource = self
    cv.showsVerticalScrollIndicator = false
    cv.contentInset = UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8)
    return cv
  }()
  
  weak var delegate: PaymentsScreenViewControllerDelegate?
  
  private var payments = [
    Payment(identifier: UUID().uuidString, name: "BNB", amount: 150, type: .card),
    Payment(identifier: UUID().uuidString, name: "PEKAO", amount: 600, type: .cash),
    Payment(identifier: UUID().uuidString, name: "MILLENIUM", amount: 50, type: .onlineWallet),
    Payment(identifier: UUID().uuidString, name: "REVOLUT", amount: 200, type: .other),
    Payment(identifier: UUID().uuidString, name: "mBANK", amount: 200, type: .card)
  ]
  
  private var currentTheme: ThemeType?
  private var currentColorTheme: ColorThemeProtocol?
  
  private var state: PaymentsViewControllerState {
    didSet {
      switch state {
      case .normal:
        addPaymentView.isHidden = true
        overlayView.isHidden = true
      case .transactionButtonPressed:
        view.backgroundColor = .yellow // ???
      case .addPayment:
        addPaymentView.isHidden = false
        overlayView.isHidden = false
      }
    }
  }
  
  init() {
    self.state = .normal
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
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
    addPaymentView.setupColorTheme(colorTheme, theme)
    collectionView.reloadData()
  }
  
  @objc private func returnButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

}

extension PaymentsScreenViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let widthCell = collectionView.frame.width - 32
      return CGSize(width: widthCell, height: (collectionView.frame.height - (5 * 4))/5)
    }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 8 }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 16 }

}

extension PaymentsScreenViewController : UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cellType = PaymentScreenCellType.getCellType(for: indexPath, arrayCount: payments.count)
    
    switch cellType {
    case .addPayment:
      delegate?.addPaymentPressed(for: indexPath)
    case .payment:
      delegate?.paymentPressed(for: indexPath)
      }
  }
  
}

extension PaymentsScreenViewController : UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    payments.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentsScreenCell.reuseIdentifier, for: indexPath) as? PaymentsScreenCell else {
      print(#line,#function,"Error: Can't get PaymentsScreenCell");
      return UICollectionViewCell() }
    
    let cellType = PaymentScreenCellType.getCellType(for: indexPath, arrayCount: payments.count)
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
    
    cell.delegate = self
    cell.indexPath = indexPath
    
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
  
}

extension PaymentsScreenViewController {
  
  private func setupSubviews() {
    view.backgroundColor = .clear
    view.addSubview(topBar)
    topBar.addSubview(returnButton)
    topBar.addSubview(screenNameLabel)
    view.addSubview(collectionView)
    view.addSubview(addPaymentView)
    view.addSubview(overlayView)
    
    topBar.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
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
    screenNameLabel.text = "All payments"
    
    addPaymentView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(188)
    }
    
    //    addPaymentView.delegate = self
    addPaymentView.isHidden = true
    
    overlayView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    overlayView.isHidden = true
    overlayView.backgroundColor = .black
    overlayView.alpha = 0.7

    collectionView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
      make.top.equalTo(topBar.snp.bottom)
    }
    
    collectionView.backgroundColor = .clear
    
  }
}

extension PaymentsScreenViewController: CellDelegate {
  func deleteButtonPressed(for indexPath: IndexPath) {
    let alert = UIAlertController(title: "Are you sure you want to delete this payment?", message: nil, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
      guard let self = self else { return }
      
      self.payments.remove(at: indexPath.row)
      
      self.collectionView.performBatchUpdates {
        self.collectionView.deleteItems(at: [indexPath])
      } completion: { completed in
        if completed {
          self.collectionView.reloadData()
        }
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
      guard let self = self else { return }
      self.collectionView.reloadItems(at: [indexPath])
    }
    
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
}
