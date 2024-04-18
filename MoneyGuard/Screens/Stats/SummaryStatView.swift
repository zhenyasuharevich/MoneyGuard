//
//  SummaryStatView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 24/11/2021.
//

import UIKit

protocol SummaryStatViewDelegate: AnyObject {
  func statsViewPeriodDidChange(newPeriod: Period)
}

final class SummaryStatView: UIView {
  
 
  private let periodSegmentedControl =  UISegmentedControl(items: Period.allCasesRawValues())
  private let summaryTransfersStack = SummaryStatsStack()
  
  var delegate: SummaryStatViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.backgroundColor = colorTheme.cellBackgroundColor
    
    summaryTransfersStack.setupColorTheme(colorTheme, theme)
    
    periodSegmentedControl.tintColor = colorTheme.textColor
    periodSegmentedControl.backgroundColor = colorTheme.cellBackgroundColor
    periodSegmentedControl.selectedSegmentTintColor = colorTheme.activeColor
    
    periodSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    periodSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorTheme.textColor], for: .normal)
  }
  
  @objc private func periodControlValueChanged() {
    if let period = Period(rawValue: periodSegmentedControl.selectedSegmentIndex) {
      delegate?.statsViewPeriodDidChange(newPeriod: period)
    }
  }
  
  func setData(object: SummaryStatsModel) {
    summaryTransfersStack.setData(object: object)
  }
  
  func getPeriod() -> Period? { Period(rawValue: periodSegmentedControl.selectedSegmentIndex) }
  
}

extension SummaryStatView {
  
  private func setupSubviews() {
    self.layer.cornerRadius = 20
    self.layer.masksToBounds = true
    
    addSubview(periodSegmentedControl)
    addSubview(summaryTransfersStack)
    
    periodSegmentedControl.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalToSuperview().offset(16)
      make.height.equalTo(40)
    }
    periodSegmentedControl.selectedSegmentIndex = Period.week.rawValue
    periodSegmentedControl.addTarget(self, action: #selector(periodControlValueChanged), for: .valueChanged)
    
    summaryTransfersStack.snp.makeConstraints { make in
      make.top.equalTo(periodSegmentedControl.snp.bottom).offset(16)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalToSuperview().offset(-16)
    }
  }
  
}
