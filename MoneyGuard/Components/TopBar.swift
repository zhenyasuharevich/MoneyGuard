//
//  TopBar.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 10/11/2021.
//

import UIKit

protocol TopBarDelegate {
  func returnButtonPressed()
}

final class TopBar: UIView {
  
  private let returnButton = UIButton()
  private let screenNameLabel = UILabel()
  
  var delegate: TopBarDelegate?
  
  init(title: String) {
    screenNameLabel.text = title
    super.init(frame: .zero)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    returnButton.setTitleColor(colorTheme.textColor, for: .normal)
    screenNameLabel.textColor = colorTheme.textColor
    backgroundColor = colorTheme.formBackgroundColor
  }
  
  @objc private func returnButtonPressed() {
    delegate?.returnButtonPressed()
  }
  
}

extension TopBar {
  
  private func setupSubviews() {
    addSubview(returnButton)
    addSubview(screenNameLabel)
    
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
  }
  
}
