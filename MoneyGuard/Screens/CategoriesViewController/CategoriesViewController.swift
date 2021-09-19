//
//  CategoriesViewController.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 19/09/2021.
//

import UIKit

enum CategoriesViewControllerState {
  case normal
  case transactionButtonPressed
}

final class CategoriesViewController: UIViewController {
  
  private let mainCategoriesView = MainCategoriesView()
  
  var categories: [Category] = []
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  private var state: CategoriesViewControllerState {
    didSet {
      switch state {
      case .normal:
        view.backgroundColor = .red
      case .transactionButtonPressed:
        view.backgroundColor = .yellow
      }
    }
  }

  init() {
      self.state = .normal
      super.init(nibName: nil, bundle: nil)
    }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSubview()
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    view.backgroundColor = colorTheme.backgroundColor
    mainCategoriesView.setupColorTheme(colorTheme, theme)
  }
  
}


extension CategoriesViewController {
  private func setupSubview() {
    view.backgroundColor = .clear

    view.addSubview(mainCategoriesView)
    
    mainCategoriesView.snp.makeConstraints { make in
      make.top.trailing.leading.bottom.equalToSuperview()
    }
    
    mainCategoriesView.backgroundColor = .clear
  }
}


