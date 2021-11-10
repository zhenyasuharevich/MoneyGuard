//
//  StatsController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 10/11/2021.
//

import UIKit

final class StatsController: UIViewController {
  
  private let topBar = UIView()
  
  override func viewDidLoad() {
    setupSubviews()
  }
  
}

extension StatsController {
  
  private func setupSubviews() {
    view.backgroundColor = .red
  }
  
}
