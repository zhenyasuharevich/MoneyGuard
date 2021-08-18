//
//  ViewController.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 27.07.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  
  private let paymentsView = PaymentsView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setubSubviews()
  }
  
  
}

extension ViewController {
  private func setubSubviews() {
    view.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.09019607843, blue: 0.1921568627, alpha: 1)
    
    view.addSubview(paymentsView)
    
    paymentsView.delegate = self
    
    paymentsView.snp.makeConstraints {make in
      make.top.equalToSuperview().offset(60)
      make.trailing.equalToSuperview()
      make.leading.equalToSuperview()
      make.height.equalTo(212) //title with button 36 + 176 collection
    }
  }
}

extension ViewController: PaymentsViewDelegate {
  func paymentPressed(for indexPath: IndexPath) { print(#line, #function, "Payment pressed with indexPath: \(indexPath)") }
  func addPaymentPressed(for indexPath: IndexPath) { print(#line, #function, "Add payment pressed with indexPath: \(indexPath)") }
  func showMorePaymentsPressed() { print(#line,#function,"Title pressed") }
}
