//
//  AddTransactionView.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 04.09.2021.
//

import UIKit

protocol AddTransactionViewDelegate: AnyObject {
  func addTransactionSubmit()
}

final class AddTransactionView: UIView {
  
  private let mainActiveView = UIView()
  private let submitButton = UIButton()
  
  private let transactionTypeLabel = UILabel()
  private let chooseStackView = UIStackView()
  private let amountLabel = UILabel()
  private let amountValueTextField = UITextField()
  private let notesLabel = UILabel()
  private let notesTextView = UITextView()
  
  private let choosePaymentView = UIView()
  private let choosePaymentLabel = UILabel()
  private let choosePaymentButton = UIButton()
  
  private let chooseCategoryView = UIView()
  private let chooseCategoryLabel = UILabel()
  private let chooseCategoryButton = UIButton()
  
  private let separatorView = UIView()
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    
    mainActiveView.backgroundColor = colorTheme.cellBackgroundColor
    submitButton.backgroundColor = colorTheme.activeColor //.none
    
    transactionTypeLabel.textColor = colorTheme.textColor
    
    choosePaymentLabel.textColor = colorTheme.textColor
    choosePaymentButton.setTitleColor(colorTheme.activeColor, for: .normal)
    choosePaymentButton.backgroundColor = colorTheme.backgroundColor
    
    chooseCategoryLabel.textColor = colorTheme.textColor
    chooseCategoryButton.setTitleColor(colorTheme.activeColor, for: .normal)
    chooseCategoryButton.backgroundColor = colorTheme.backgroundColor
    
    amountLabel.textColor = colorTheme.textColor
    amountValueTextField.backgroundColor = colorTheme.backgroundColor
    amountValueTextField.textColor = colorTheme.textColor.withAlphaComponent(0.8)
    amountValueTextField.tintColor = colorTheme.textColor.withAlphaComponent(0.8)
    
    notesLabel.textColor = colorTheme.textColor
    notesTextView.backgroundColor = colorTheme.backgroundColor
    notesTextView.textColor = colorTheme.textColor.withAlphaComponent(0.8)
    notesTextView.tintColor = colorTheme.textColor.withAlphaComponent(0.8)
    
    separatorView.backgroundColor = colorTheme.activeColor
  }
  
  @objc private func submitButtonPressed() {
    print("add transaction Submit pressed")
  }
  
}

extension AddTransactionView {
  private func setupSubviews() {
    addSubview(mainActiveView)
    addSubview(submitButton)
    
    mainActiveView.addSubview(transactionTypeLabel)
    mainActiveView.addSubview(chooseStackView)
    mainActiveView.addSubview(amountLabel)
    mainActiveView.addSubview(amountValueTextField)
    mainActiveView.addSubview(notesLabel)
    mainActiveView.addSubview(notesTextView)
    mainActiveView.addSubview(separatorView)
    
    mainActiveView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(16)
      make.trailing.equalTo(-16)
      make.height.equalTo(260)
    }
    mainActiveView.layer.cornerRadius = 20
    mainActiveView.clipsToBounds = true
    
    submitButton.snp.makeConstraints { make in
      make.top.equalTo(mainActiveView.snp.bottom).offset(20)
      make.trailing.equalToSuperview().offset(-32)
      make.leading.equalToSuperview().offset(32)
      make.height.equalTo(40)
    }
    submitButton.setTitle("Submit", for: .normal)
    submitButton.layer.cornerRadius = 20
    submitButton.layer.borderWidth = 1
    submitButton.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
//    submitButton.isEnabled = false
    
    transactionTypeLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().offset(-8)
      make.height.equalTo(24)
    }
    transactionTypeLabel.text = "Transfer money to available payment"
    transactionTypeLabel.font = .systemFont(ofSize: 18, weight: .medium)
    transactionTypeLabel.textAlignment = .center
    
    separatorView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalTo(transactionTypeLabel.snp.bottom).offset(2)
      make.height.equalTo(1)
    }

    chooseStackView.snp.makeConstraints { make in
      make.top.equalTo(transactionTypeLabel.snp.bottom).offset(8)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(80)
    }
    chooseStackView.axis = .horizontal
    chooseStackView.distribution = .fillEqually
    chooseStackView.spacing = 8
    
    amountLabel.snp.makeConstraints { make in
      make.top.equalTo(chooseStackView.snp.bottom).offset(8)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(32)
    }
    amountLabel.text = "Amount: "
    amountLabel.font = .systemFont(ofSize: 16, weight: .medium)
    
    amountValueTextField.snp.makeConstraints { make in
      make.top.equalTo(chooseStackView.snp.bottom).offset(8)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalTo(amountLabel.snp.trailing).offset(16)
      make.height.equalTo(32)
    }
    amountValueTextField.textAlignment = .center
    amountValueTextField.layer.cornerRadius = 8
    amountValueTextField.hideKeyboardWhenDoneButtonTapped()
    
    notesTextView.snp.makeConstraints { make in
      make.top.equalTo(amountValueTextField.snp.bottom).offset(8)
      make.bottom.equalToSuperview().offset(-16)
      make.leading.equalTo(amountValueTextField)
      make.trailing.equalTo(amountValueTextField)
    }
    notesTextView.textAlignment = .center
    notesTextView.layer.cornerRadius = 8
    notesTextView.hideKeyboardWhenDoneButtonTapped()
    
    notesLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(32)
      make.trailing.equalTo(notesTextView.snp.leading).offset(-16)
      make.centerY.equalTo(notesTextView)
    }
    notesLabel.text = "Notes: "
    notesLabel.font = .systemFont(ofSize: 16, weight: .medium)
    
    configureStackView()
  }
  
  private func configureStackView() {
    choosePaymentView.addSubview(choosePaymentLabel)
    choosePaymentView.addSubview(choosePaymentButton)
    choosePaymentView.backgroundColor = .clear
    
    chooseCategoryView.addSubview(chooseCategoryLabel)
    chooseCategoryView.addSubview(chooseCategoryButton)
    chooseCategoryView.backgroundColor = .clear
    
    chooseStackView.addArrangedSubview(choosePaymentView)
    chooseStackView.addArrangedSubview(chooseCategoryView)
    
    choosePaymentLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalToSuperview().offset(8)
      make.height.equalTo(16)
    }
    choosePaymentLabel.text = "Payment:"
    choosePaymentLabel.textAlignment = .left
    choosePaymentLabel.font = .systemFont(ofSize: 16, weight: .regular)
    
    choosePaymentButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(choosePaymentLabel.snp.bottom).offset(8)
      make.bottom.equalToSuperview()
    }
    choosePaymentButton.setTitle("Choose Payment", for: .normal)
    choosePaymentButton.layer.cornerRadius = 8
    choosePaymentButton.clipsToBounds = true
    
    chooseCategoryLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalToSuperview().offset(8)
      make.height.equalTo(16)
    }
    chooseCategoryLabel.text = "Category:"
    chooseCategoryLabel.textAlignment = .left
    chooseCategoryLabel.font = .systemFont(ofSize: 16, weight: .regular)
    
    chooseCategoryButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(choosePaymentLabel.snp.bottom).offset(8)
      make.bottom.equalToSuperview()
    }
    chooseCategoryButton.setTitle("Choose Category", for: .normal)
    chooseCategoryButton.layer.cornerRadius = 8
    chooseCategoryButton.clipsToBounds = true
  }
}
