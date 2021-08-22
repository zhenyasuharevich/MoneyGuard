//
//  TabBarView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 20/08/2021.
//

import UIKit

final class TopBarView: UIView {
  
  private let topBarSettingButton = UIButton()
  private let topBarLogotype = UILabel()
  private let image = UIImage(named: "imageForTopBar")
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupForSettingsButton()
    self.setupSubViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func buttonAction(_ sender:UIButton!) {
    print("Button tapped")
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    topBarLogotype.textColor = colorTheme.textColor
    topBarSettingButton.backgroundColor = colorTheme.textColor
    image?.withTintColor(colorTheme.textColor)
    self.backgroundColor = colorTheme.formBackgroundColor
  }
  
  private func setupForSettingsButton() {
    topBarSettingButton.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
  }
  
}

extension TopBarView {
  private func setupSubViews() {
    
    self.addSubview(topBarSettingButton)
    self.addSubview(topBarLogotype)
    
    self.layer.cornerRadius = 20
    self.layer.masksToBounds = true
    self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    
    topBarSettingButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-28)
      make.trailing.equalToSuperview().offset(-28)
      make.height.equalTo(32)
      make.width.equalTo(32)
    }
    
    topBarSettingButton.setImage(image, for: .normal)
    
    topBarLogotype.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(28)
      make.centerY.equalTo(topBarSettingButton).offset(0)
    }
    
    topBarLogotype.text = "MoneyGuard"
  }
  
}
