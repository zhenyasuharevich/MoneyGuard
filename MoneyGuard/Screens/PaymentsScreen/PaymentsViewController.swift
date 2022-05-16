//
//  PaymentsScreenViewController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 26/09/2021.
//

import UIKit
import SwiftUI

protocol PaymentsViewControllerDelegate: AnyObject {
  func removePayment(for indexPath: IndexPath)
  func addNewPayment(payment: Payment)
}

enum PaymentsViewControllerContentType {
  case scrollingListForChoose
  case listWithInteractiveCell
}

final class PaymentsViewController: UIViewController {
  
  private let topBar = TopBar(title: "Payments")
  private let overlayView = UIView()
  
  var selectPaymentCompletion: ((Payment) -> Void)?
  
  lazy var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(PaymentsScreenCell.self, forCellWithReuseIdentifier: PaymentsScreenCell.reuseIdentifier)
    cv.register(AddPaymentCell.self, forCellWithReuseIdentifier: AddPaymentCell.reuseIdentifier)
    cv.delegate = self
    cv.dataSource = self
    cv.showsVerticalScrollIndicator = false
    cv.contentInset = UIEdgeInsets(top: 16,
                                   left: 8,
                                   bottom: 48,
                                   right: 8)
    return cv
  }()
  
  weak var delegate: PaymentsViewControllerDelegate?
  
  private var payments: [Payment] = []
  
  private var currentTheme: ThemeType?
  private var currentColorTheme: ColorThemeProtocol?
  
  private var contentType: PaymentsViewControllerContentType
  
  init(contentType: PaymentsViewControllerContentType) {
    self.contentType = contentType
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
    
    topBar.setupColorTheme(colorTheme, theme)
    view.backgroundColor = colorTheme.backgroundColor
    collectionView.reloadData()
  }
  
  func setData(payment: [Payment]) {
    self.payments = payment
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }

}

extension PaymentsViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let widthCell = collectionView.frame.width - 32
    
    if indexPath.section == 1 {
      return CGSize(width: widthCell, height: collectionView.frame.height)
    } else {
      return CGSize(width: widthCell, height: (collectionView.frame.height - (5 * 4))/5)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 8 }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 16 }

}

extension PaymentsViewController : UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard !(self.contentType == .listWithInteractiveCell) else { return }
    guard let completion = self.selectPaymentCompletion else { print(#line,#function,"Error: no select paymnet completion"); return }
    let payment = payments[indexPath.row]
    self.dismiss(animated: true) {
      DispatchQueue.main.async {
        completion(payment)
      }
    }
  }
  
}

extension PaymentsViewController : UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if section == 0 {
      return payments.count
    } else if section == 1 {
      
      return 1
    }
    
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellType = PaymentScreenCellType.getCellType(for: indexPath)
    switch cellType {
    case .payment:
      
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentsScreenCell.reuseIdentifier, for: indexPath) as? PaymentsScreenCell else { print(#line,#function,"Error: Can't get PaymentsScreenCell");
        return UICollectionViewCell() }
      
      let payment = payments[indexPath.row]
      cell.setupData(indexPath: indexPath, payment: payment, screenContentType: self.contentType)
      cell.delegate = self
      
      if let colorTheme = self.currentColorTheme,
         let theme = self.currentTheme {
        cell.setupColorTheme(colorTheme, theme)
      }
      return cell
      
    case .addPayment:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPaymentCell.reuseIdentifier, for: indexPath) as? AddPaymentCell else { print(#line,#function,"Error: Can't get PaymentsCell");
        return UICollectionViewCell() }
      print("Add payment cell")
      
      if let colorTheme = self.currentColorTheme,
         let theme = self.currentTheme {
        cell.setupColorTheme(colorTheme, theme)
      }
      cell.delegate = self
      
      return cell
    }

  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard contentType == .listWithInteractiveCell else { return 1}
    return 2
  }
  
}

extension PaymentsViewController {
  
  private func setupSubviews() {
    view.backgroundColor = .clear
    view.addSubview(topBar)
    view.addSubview(collectionView)
    view.addSubview(overlayView)
    
    topBar.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(DashboardConstants.TopBar.height)
    }
    topBar.layer.cornerRadius = 20
    topBar.layer.masksToBounds = true
    topBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    topBar.delegate = self
    
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

extension PaymentsViewController: CellDelegate {
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
          self.delegate?.removePayment(for: indexPath)
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

extension PaymentsViewController: AddPaymentViewDelegate {
  func addPayment(newPayment: Payment) {
    guard let delegate = self.delegate else { return }
    delegate.addNewPayment(payment: newPayment)
  }
}

extension PaymentsViewController: TopBarDelegate {
  func returnButtonPressed() {
    dismiss(animated: true)
  }
}
