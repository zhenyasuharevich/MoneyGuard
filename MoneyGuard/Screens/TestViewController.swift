//
//  TestViewController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 19/08/2021.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {
//  private let tabBar = TabBarView()
  private let lastTransactions = LastTransactions()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setubSubViews()
  }
  
}

extension TestViewController {
  private func setubSubViews() {
//    view.addSubview(tabBar)
//
//    tabBar.snp.makeConstraints { make in
//      make.top.equalToSuperview().offset(0)
//      make.trailing.equalToSuperview().offset(0)
//      make.leading.equalToSuperview().offset(0)
//      make.height.equalTo(UIScreen.main.bounds.height > 736 ? 120 : 100)
//    }
    view.addSubview(lastTransactions)
    
    lastTransactions.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(0)
      make.trailing.equalToSuperview().offset(0)
      make.leading.equalToSuperview().offset(0)
      make.height.equalTo(UIScreen.main.bounds.height > 736 ? 200 : 180)
    }
    
    lastTransactions.backgroundColor = .blue
  }
  
}
