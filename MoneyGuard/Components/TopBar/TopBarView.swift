//
//  TabBarView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 20/08/2021.
//

import UIKit

protocol TopBarViewDelegate: AnyObject {
  func settingsButtonPressed()
}

final class TopBarView: UIView {
  
  private let topBarSettingButton = UIButton()
  private let topBarLogotype = UILabel()
  private let settingsIcon: UIImage? = {
    UIImage(named: "imageForTopBar")?.withRenderingMode(.alwaysTemplate)
  }()
  
  weak var delegate: TopBarViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupForSettingsButton()
    self.setupSubViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func buttonAction(_ sender:UIButton!) {
    delegate?.settingsButtonPressed()
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    topBarLogotype.textColor = colorTheme.textColor
    topBarSettingButton.imageView?.tintColor = colorTheme.textColor
    self.backgroundColor = colorTheme.formBackgroundColor
  }
  
  private func setupForSettingsButton() {
    topBarSettingButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
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
      make.height.equalTo(24)
      make.width.equalTo(24)
    }
    
    topBarSettingButton.setImage(settingsIcon, for: .normal)
    
    topBarLogotype.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(28)
      make.centerY.equalTo(topBarSettingButton).offset(0)
    }
    
    topBarLogotype.text = "MoneyGuard"
  }
  
}
