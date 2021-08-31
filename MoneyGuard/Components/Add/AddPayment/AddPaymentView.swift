//
//  AddPaymentView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 29/08/2021.
//

import UIKit

protocol AddPaymentViewDelegate: AnyObject {
  func addPayment(newPayment: Payment)
}

class AddPaymentView: UIView {

  private let mainAddPaymentView = UIView()
  private let paymentNameLabel = UILabel()
  private let paymentNameTextField = UITextField()
  private let startAmountLabel = UILabel()
  private let startAmountTextField = UITextField()
  private let typeOfPaymentsLabel = UILabel()
  
  private let cashTypeButton = UIButton()
  private let cardTypeButton = UIButton()
  private let onlineWalletTypeButton = UIButton()
  private let otherTypeButton = UIButton()
  private let addPaymentButton = UIButton()
  
  private var selectedPaymentType: PaymentType = .other
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  weak var delegate: AddPaymentViewDelegate?
  
  private var isCreateEnable: Bool {
    didSet {
      guard let colorTheme = self.currentColorTheme else { print(#line,#function,"Error: Don't found color theme"); return }
      
      if isCreateEnable {
        addPaymentButton.backgroundColor = colorTheme.activeColor
        addPaymentButton.isEnabled = true
      } else {
        addPaymentButton.isEnabled = false
        addPaymentButton.backgroundColor = .clear
      }
    }
  }
  
  override init(frame: CGRect) {
    isCreateEnable = false
    super.init(frame: .zero)
    setupSubview()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    
    mainAddPaymentView.backgroundColor = colorTheme.cellBackgroundColor
    
    paymentNameLabel.textColor = colorTheme.textColor
    paymentNameTextField.backgroundColor = colorTheme.backgroundColor
    paymentNameTextField.textColor = colorTheme.textColor.withAlphaComponent(0.8)
    paymentNameTextField.tintColor = colorTheme.textColor.withAlphaComponent(0.8)
    
    startAmountLabel.textColor = colorTheme.textColor
    startAmountTextField.backgroundColor = colorTheme.backgroundColor
    startAmountTextField.textColor = colorTheme.textColor.withAlphaComponent(0.8)
    startAmountTextField.tintColor = colorTheme.textColor.withAlphaComponent(0.8)
    
    typeOfPaymentsLabel.textColor = colorTheme.textColor
    
    cashTypeButton.layer.borderColor = colorTheme.textColor.cgColor
    cashTypeButton.setTitleColor(colorTheme.textColor, for: .normal)
    
    cardTypeButton.layer.borderColor = colorTheme.textColor.cgColor
    cardTypeButton.setTitleColor(colorTheme.textColor, for: .normal)
    
    onlineWalletTypeButton.layer.borderColor = colorTheme.textColor.cgColor
    onlineWalletTypeButton.setTitleColor(colorTheme.textColor, for: .normal)
    
    otherTypeButton.layer.borderColor = colorTheme.textColor.cgColor
    otherTypeButton.setTitleColor(colorTheme.textColor, for: .normal)

    addPaymentButton.backgroundColor = .clear
    
    changeButtonsSelection(oldType: .other, newType: .other)
  }
  
  private func paymentTypePressed(type: PaymentType) {
    guard !(selectedPaymentType == type) else { print("Error: \(type.rawValue) already selected"); return }
    changeButtonsSelection(oldType: selectedPaymentType, newType: type)
  }
  
  private func changeButtonsSelection(oldType: PaymentType, newType: PaymentType) {
    deselectButtons()
    selectButton(with: newType)
  }
  
  private func deselectButtons() {
    guard let colorTheme = self.currentColorTheme else { print(#line,#function,"Error: Don't found color theme"); return }
    cardTypeButton.backgroundColor = .clear
    cashTypeButton.backgroundColor = .clear
    onlineWalletTypeButton.backgroundColor = .clear
    otherTypeButton.backgroundColor = .clear
    
    cardTypeButton.setTitleColor(colorTheme.textColor, for: .normal)
    cashTypeButton.setTitleColor(colorTheme.textColor, for: .normal)
    onlineWalletTypeButton.setTitleColor(colorTheme.textColor, for: .normal)
    otherTypeButton.setTitleColor(colorTheme.textColor, for: .normal)
  }
  
  private func selectButton(with type: PaymentType) {
    guard let colorTheme = self.currentColorTheme else { print(#line,#function,"Error: Don't found color theme"); return }
    let newSelectedButton = getButtonFor(type: type)
    newSelectedButton.backgroundColor = colorTheme.activeColor
    newSelectedButton.setTitleColor(.white, for: .normal)
    selectedPaymentType = type
  }
  
  private func getButtonFor(type: PaymentType) -> UIButton {
    switch type {
    case .card:
      return self.cardTypeButton
    case .cash:
      return self.cashTypeButton
    case .onlineWallet:
      return self.onlineWalletTypeButton
    case .other:
      return self.otherTypeButton
    }
  }
  
  @objc func createButtonTapped(){
    guard let text = paymentNameTextField.text,
          !text.isEmpty else { print(#line,#function,"Error: Can't create payment with empty name"); return }
    
    let paymentName = text
    var startAmount: Double = 0
    
    if let amountText = startAmountTextField.text,
       !amountText.isEmpty,
       let amount = Double(amountText) {
      startAmount = amount
    }
    
    let newPayment = Payment(identifier: UUID().uuidString, name: paymentName, amount: startAmount, type: selectedPaymentType)
    delegate?.addPayment(newPayment: newPayment)
  }
  
  @objc func cashButtonPressed() { paymentTypePressed(type: .cash) }
  @objc func cardButtonPressed() { paymentTypePressed(type: .card) }
  @objc func onlineWalletButtonPressed() { paymentTypePressed(type: .onlineWallet) }
  @objc func otherButtonPressed() { paymentTypePressed(type: .other) }
}

extension AddPaymentView: UITextFieldDelegate {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      endEditing(true)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    endEditing(true)
    return true
  }
  
  @objc private func paymentNameTextFieldValueChanged(_ sender: UITextField) {
    guard let text = sender.text,
          !text.isEmpty else { isCreateEnable = false; return }
    isCreateEnable = true
  }

}

extension AddPaymentView {
  private func setupSubview() {
    backgroundColor = .clear
    
    paymentNameTextField.delegate = self
    
    addSubview(mainAddPaymentView)
    mainAddPaymentView.addSubview(paymentNameLabel)
    mainAddPaymentView.addSubview(paymentNameTextField)
    mainAddPaymentView.addSubview(startAmountLabel)
    mainAddPaymentView.addSubview(startAmountTextField)
    mainAddPaymentView.addSubview(typeOfPaymentsLabel)
    mainAddPaymentView.addSubview(cashTypeButton)
    mainAddPaymentView.addSubview(cardTypeButton)
    mainAddPaymentView.addSubview(onlineWalletTypeButton)
    mainAddPaymentView.addSubview(otherTypeButton)
    addSubview(addPaymentButton)
    
    mainAddPaymentView.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(16)
          make.trailing.leading.equalToSuperview()
          make.height.equalTo(428)
        }
    
    mainAddPaymentView.layer.masksToBounds = true
    mainAddPaymentView.layer.cornerRadius = 20
    
    paymentNameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(24)
    }
    
    paymentNameLabel.textAlignment = .center
    paymentNameLabel.text = "Payment name"
    
    paymentNameTextField.snp.makeConstraints { make in
      make.top.equalTo(paymentNameLabel.snp.bottom).offset(8)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(36)
    }
    
    paymentNameTextField.layer.cornerRadius = 8
    paymentNameTextField.textAlignment = .center
    paymentNameTextField.hideKeyboardWhenDoneButtonTapped()
    paymentNameTextField.addTarget(self, action: #selector(paymentNameTextFieldValueChanged(_:)), for: .editingChanged)
    
    startAmountLabel.snp.makeConstraints { make in
      make.top.equalTo(paymentNameTextField.snp.bottom).offset(8)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(24)
    }
    
    startAmountLabel.textAlignment = .center
    startAmountLabel.text = "Start amount"
    
    startAmountTextField.snp.makeConstraints { make in
      make.top.equalTo(startAmountLabel.snp.bottom).offset(8)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(36)
    }
    
    startAmountTextField.keyboardType = .decimalPad
    startAmountTextField.layer.cornerRadius = 8
    startAmountTextField.textAlignment = .center
    startAmountTextField.text = "\(Double(0))"
    startAmountTextField.hideKeyboardWhenDoneButtonTapped()

    typeOfPaymentsLabel.snp.makeConstraints { make in
      make.top.equalTo(startAmountTextField.snp.bottom).offset(8)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(24)
    }

    typeOfPaymentsLabel.textAlignment = .center
    typeOfPaymentsLabel.text = "Type"
    
    cashTypeButton.snp.makeConstraints { make in
      make.top.equalTo(typeOfPaymentsLabel.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(40)
    }
    cashTypeButton.setTitle("cash", for: .normal)
    cashTypeButton.layer.cornerRadius = 8
    cashTypeButton.layer.borderWidth = 1
    cashTypeButton.addTarget(self, action: #selector(cashButtonPressed), for: .touchUpInside)

    cardTypeButton.snp.makeConstraints { make in
      make.top.equalTo(cashTypeButton.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(40)
    }
    cardTypeButton.setTitle("card", for: .normal)
    cardTypeButton.layer.cornerRadius = 8
    cardTypeButton.layer.borderWidth = 1
    cardTypeButton.addTarget(self, action: #selector(cardButtonPressed), for: .touchUpInside)

    onlineWalletTypeButton.snp.makeConstraints { make in
      make.top.equalTo(cardTypeButton.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(40)
    }
    onlineWalletTypeButton.setTitle("online wallet", for: .normal)
    onlineWalletTypeButton.layer.cornerRadius = 8
    onlineWalletTypeButton.layer.borderWidth = 1
    onlineWalletTypeButton.addTarget(self, action: #selector(onlineWalletButtonPressed), for: .touchUpInside)

    otherTypeButton.snp.makeConstraints { make in
      make.top.equalTo(onlineWalletTypeButton.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(40)
    }
    otherTypeButton.setTitle("other", for: .normal)
    otherTypeButton.layer.cornerRadius = 8
    otherTypeButton.layer.borderWidth = 1
    otherTypeButton.addTarget(self, action: #selector(otherButtonPressed), for: .touchUpInside)

    addPaymentButton.snp.makeConstraints { make in
      make.top.equalTo(mainAddPaymentView.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(40)
    }
    addPaymentButton.setTitle("Create", for: .normal)
    addPaymentButton.layer.cornerRadius = 20
    addPaymentButton.layer.borderWidth = 1
    addPaymentButton.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    addPaymentButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    addPaymentButton.isEnabled = false
  }
  
}





