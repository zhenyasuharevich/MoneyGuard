//
//  StatsView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 24/08/2021.
//

import UIKit
import SnapKit

enum Period: Int {
  case week = 0
  case month = 1
  case year = 2
  
  static func allCasesRawValues() -> [String] {
    return ["Week","Month","Year"]
  }
}

class StatsView: UIView {

  private let statsHeaderView = UIView()
  private let statsTitleLabel = UILabel()
  
  private let statsButtonView = UIView()
  private let statsButtonLabel = UILabel()
  private let statsButtonImageView = UIImageView()
  private let statsMainButton = UIButton()
  
  private let statsHeaderLineView = UIView()
  
  private let periodSegmentedControl =  UISegmentedControl(items: Period.allCasesRawValues())
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    self.backgroundColor = colorTheme.cellBackgroundColor
    
    statsButtonView.backgroundColor = colorTheme.activeColor
    statsTitleLabel.textColor = colorTheme.textColor
    statsHeaderLineView.backgroundColor = colorTheme.activeColor
  }
  
  @objc func buttonPressed() {
    print("button tapped!")
  }
  
  @objc private func periodControlValueChanged() {
    print(periodSegmentedControl.selectedSegmentIndex)
  }
  
}

extension StatsView {
  private func setupSubviews() {
    
    self.layer.cornerRadius = 20
    self.layer.masksToBounds = true
    
    addSubview(statsHeaderView)
    statsHeaderView.addSubview(statsTitleLabel)
    statsHeaderView.addSubview(statsButtonView)
    statsButtonView.addSubview(statsButtonLabel)
    statsButtonView.addSubview(statsButtonImageView)
    statsButtonView.addSubview(statsMainButton)
    addSubview(statsHeaderLineView)
    addSubview(periodSegmentedControl)
    
    
    statsHeaderView.snp.makeConstraints{ make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(72)
    }
    
    statsTitleLabel.snp.makeConstraints{ make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
    }
    
    statsTitleLabel.text = "Stats"
    statsTitleLabel.textAlignment = .left
    statsTitleLabel.font = .systemFont(ofSize: 36, weight: .semibold)
    
    statsButtonView.snp.makeConstraints{ make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(44)
      make.width.equalTo(104)
    }
    
    statsButtonView.layer.cornerRadius = 10
    
    statsButtonLabel.snp.makeConstraints{ make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(12)
    }
    statsButtonLabel.textColor = .white
    statsButtonLabel.text = "ALL"
    statsButtonLabel.textAlignment = .left
    statsButtonLabel.font = .systemFont(ofSize: 24, weight: .semibold)
    
    statsButtonImageView.snp.makeConstraints{ make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-12)
      make.height.width.equalTo(24)
    }
    
    statsButtonImageView.backgroundColor = .red
    
    statsMainButton.snp.makeConstraints{ make in
      make.top.trailing.bottom.leading.equalToSuperview()
    }
    
    statsMainButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    
    statsHeaderLineView.snp.makeConstraints{ make in
      make.top.equalTo(statsHeaderView.snp.bottom)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(1)
    }
    
    periodSegmentedControl.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalTo(statsHeaderView.snp.bottom).offset(16)
      make.height.equalTo(52)
    }
    
//    periodSegmentedControl.addTarget(self, action: #selector(periodControlValueChanged), for: .valueChanged)
    
  }
  
}
