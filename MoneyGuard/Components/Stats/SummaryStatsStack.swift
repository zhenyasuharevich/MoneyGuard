//
//  SummaryStatsStack.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 03/11/2021.
//

import UIKit

final class SummaryStatsStack: UIStackView {
  
  private let incomeLabel = UILabel()
  private let incomeValueLabel = UILabel()
  private let spendLabel = UILabel()
  private let spendValueLabel = UILabel()
  private let diffLabel = UILabel()
  private let diffValueLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    incomeLabel.textColor = colorTheme.textColor.withAlphaComponent(0.6)
    incomeValueLabel.textColor = colorTheme.textColor
    
    spendLabel.textColor = colorTheme.textColor.withAlphaComponent(0.6)
    spendValueLabel.textColor = colorTheme.textColor
    
    diffLabel.textColor = colorTheme.textColor.withAlphaComponent(0.6)
    diffValueLabel.textColor = colorTheme.textColor
  }
  
  func setData(object: SummaryStatsModel) {
    incomeValueLabel.text = "\(object.income)"
    spendValueLabel.text = "\(object.spend)"
    diffValueLabel.text = "\(object.income - object.spend)"
  }
  
}

extension SummaryStatsStack {
  private func setupSubviews() {
    axis = .horizontal
    distribution = .fillEqually
    spacing = 8
    
    let incomeStack = UIStackView()
    incomeStack.axis = .vertical
    incomeStack.distribution = .fillProportionally
    
    let spendStack = UIStackView()
    spendStack.axis = .vertical
    spendStack.distribution = .fillProportionally
    
    let diffStack = UIStackView()
    diffStack.axis = .vertical
    diffStack.distribution = .fillProportionally
    
    addArrangedSubview(incomeStack)
    addArrangedSubview(spendStack)
    addArrangedSubview(diffStack)
    
    incomeLabel.text = "income"
    incomeLabel.textAlignment = .center
    incomeLabel.font = .systemFont(ofSize: 16, weight: .regular)
    incomeLabel.adjustsFontSizeToFitWidth = true
    incomeLabel.minimumScaleFactor = 0.6
    
    incomeValueLabel.textAlignment = .center
    incomeValueLabel.font = .systemFont(ofSize: 24, weight: .bold)
    incomeValueLabel.adjustsFontSizeToFitWidth = true
    incomeValueLabel.minimumScaleFactor = 0.6
    
    spendLabel.text = "spend"
    spendLabel.textAlignment = .center
    spendLabel.font = .systemFont(ofSize: 16, weight: .regular)
    spendLabel.adjustsFontSizeToFitWidth = true
    spendLabel.minimumScaleFactor = 0.6
    
    spendValueLabel.textAlignment = .center
    spendValueLabel.font = .systemFont(ofSize: 24, weight: .bold)
    spendValueLabel.adjustsFontSizeToFitWidth = true
    spendValueLabel.minimumScaleFactor = 0.6
    
    diffLabel.text = "diff"
    diffLabel.textAlignment = .center
    diffLabel.font = .systemFont(ofSize: 16, weight: .regular)
    diffLabel.adjustsFontSizeToFitWidth = true
    diffLabel.minimumScaleFactor = 0.6
    
    diffValueLabel.textAlignment = .center
    diffValueLabel.font = .systemFont(ofSize: 24, weight: .bold)
    diffValueLabel.adjustsFontSizeToFitWidth = true
    diffValueLabel.minimumScaleFactor = 0.6
    
    incomeStack.addArrangedSubview(incomeLabel)
    incomeStack.addArrangedSubview(incomeValueLabel)
    
    spendStack.addArrangedSubview(spendLabel)
    spendStack.addArrangedSubview(spendValueLabel)
    
    diffStack.addArrangedSubview(diffLabel)
    diffStack.addArrangedSubview(diffValueLabel)
  }
}
