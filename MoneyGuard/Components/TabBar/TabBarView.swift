//
//  TabBarView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 20/08/2021.
//

import UIKit

class TabBarView: UIView {
  
  let tabBarSettingButton = UIButton()
  let tabBarLogotype = UILabel()
  
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
  
  private func setupForSettingsButton() {
    tabBarSettingButton.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
  }
  
}

extension TabBarView {
  private func setupSubViews() {
    
    self.addSubview(tabBarSettingButton)
    self.addSubview(tabBarLogotype)
    
    self.backgroundColor = .black
    self.layer.cornerRadius = 20
    self.layer.masksToBounds = true
    self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    
    tabBarSettingButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-28)
      make.trailing.equalToSuperview().offset(-28)
      make.height.equalTo(32)
      make.width.equalTo(32)
    }
    
    tabBarSettingButton.backgroundColor = .none
    let image = UIImage(named: "imageForTabBar")?.withTintColor(.white)
    tabBarSettingButton.setImage(image, for: .normal)
    
    tabBarLogotype.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(28)
      make.centerY.equalTo(tabBarSettingButton).offset(0)
    }
    
    tabBarLogotype.text = "MoneyGuard"
    tabBarLogotype.textColor = .white
  }
  
}
