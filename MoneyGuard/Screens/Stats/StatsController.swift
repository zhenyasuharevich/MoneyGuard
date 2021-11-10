//
//  StatsController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 10/11/2021.
//

import UIKit

final class StatsController: UIViewController {
  
  private let topBar = TopBar(title: "Stats")
  
  override func viewDidLoad() {
    setupSubviews()
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    view.backgroundColor = colorTheme.backgroundColor
    topBar.setupColorTheme(colorTheme, theme)
  }
  
}

extension StatsController {
  
  private func setupSubviews() {
    view.addSubview(topBar)
    
    topBar.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(DashboardConstants.TopBar.height)
    }
    topBar.layer.cornerRadius = 20
    topBar.layer.masksToBounds = true
    topBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    topBar.delegate = self
  }
  
}

extension StatsController: TopBarDelegate {
  func returnButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
}
