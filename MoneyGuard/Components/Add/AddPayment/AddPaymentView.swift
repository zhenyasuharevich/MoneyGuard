//
//  AddPaymentView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 29/08/2021.
//

import UIKit

enum AddPaymentState {
  case cashButton, cardButton, onlineButton, otherButton
}

class AddPaymentView: UIView {

  private let mainAddPaymentView = UIView()
  private let addPaymentNameLabel = UILabel()
  private let addPaymentNameTextField = UITextField()
  private let startAmountLabel = UILabel()
  private let startAmountTextField = UITextField()
  private let typeOfPaymentsLabel = UILabel()
  private let cashTypeButton = UIButton()
  private let cashTypeButtonTitleLabel = UILabel()
  private let cardTypeButton = UIButton()
  private let cardTypeButtonTitleLabel = UILabel()
  private let onlineWalletTypeButton = UIButton()
  private let onlineWalletButtonTitleLabel = UILabel()
  private let otherTypeButton = UIButton()
  private let otherButtonTitleLabel = UILabel()
  private let addPaymentButton = UIButton()
  private let addPaymentButtonTitle = UILabel()
  
  private var buttonIsSelected : Bool = false
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?
  
  override init(frame: CGRect) {
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
    addPaymentNameLabel.textColor = colorTheme.textColor
    addPaymentNameTextField.backgroundColor = colorTheme.backgroundColor
    startAmountLabel.textColor = colorTheme.textColor
    startAmountTextField.backgroundColor = colorTheme.backgroundColor
    typeOfPaymentsLabel.textColor = colorTheme.textColor
    cashTypeButton.backgroundColor = colorTheme.cellBackgroundColor
    cashTypeButton.layer.borderColor = colorTheme.textColor.cgColor
    cashTypeButtonTitleLabel.textColor = colorTheme.textColor
    cardTypeButton.backgroundColor = colorTheme.cellBackgroundColor
    cardTypeButton.layer.borderColor = colorTheme.textColor.cgColor
    cardTypeButtonTitleLabel.textColor = colorTheme.textColor
    onlineWalletTypeButton.backgroundColor = colorTheme.cellBackgroundColor
    onlineWalletTypeButton.layer.borderColor = colorTheme.textColor.cgColor
    onlineWalletButtonTitleLabel.textColor = colorTheme.textColor
    otherTypeButton.backgroundColor = colorTheme.cellBackgroundColor
    otherTypeButton.layer.borderColor = colorTheme.textColor.cgColor
    otherButtonTitleLabel.textColor = colorTheme.textColor
    addPaymentButton.backgroundColor = colorTheme.activeColor
    addPaymentButtonTitle.textColor = colorTheme.textColor
  }
  
  @objc func buttonTapped(){
    print("Adding new payment...")
  }
  
  @objc func cashButtonIsChosen() {
    cashTypeButton.backgroundColor = currentColorTheme?.activeColor
    cardTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    onlineWalletTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    otherTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    buttonIsSelected = true
    print("button is chosen...")
  }
  
  @objc func cardButtonIsChosen() {
    cashTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    cardTypeButton.backgroundColor = currentColorTheme?.activeColor
    onlineWalletTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    otherTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    buttonIsSelected = true
    print("button is chosen...")
  }
  
  @objc func onlineWalletButtonIsChosen() {
    cashTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    cardTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    onlineWalletTypeButton.backgroundColor = currentColorTheme?.activeColor
    otherTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    buttonIsSelected = true
    print("button is chosen...")
  }
  
  @objc func otherButtonIsChosen() {
    cashTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    cardTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    onlineWalletTypeButton.backgroundColor = currentColorTheme?.cellBackgroundColor
    otherTypeButton.backgroundColor = currentColorTheme?.activeColor
    buttonIsSelected = true
    print("button is chosen...")
  }
}

extension AddPaymentView: UITextFieldDelegate {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      endEditing(true)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool { //func to hide keyboard, when button "return" is tapped
    endEditing(true)
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) { // func to hide button, when textfield is empty
    if addPaymentNameTextField.text == "" || startAmountTextField.text == "" || buttonIsSelected == false {
      addPaymentButton.isHidden = true
    }
    else {
      addPaymentButton.isHidden = false
    }
  }
  
  private func textFieldWillEndEditing(_ textField: UITextField) { // func to hide button, when textfield is empty
    if addPaymentNameTextField.text == "" || startAmountTextField.text == "" || buttonIsSelected == false {
      addPaymentButton.isHidden = true
    }
    else {
      addPaymentButton.isHidden = false
    }
  }

}

extension AddPaymentView {
  private func setupSubview() {
    backgroundColor = .clear
    
    addPaymentNameTextField.delegate = self
    
    addSubview(mainAddPaymentView)
    mainAddPaymentView.addSubview(addPaymentNameLabel)
    mainAddPaymentView.addSubview(addPaymentNameTextField)
    mainAddPaymentView.addSubview(startAmountLabel)
    mainAddPaymentView.addSubview(startAmountTextField)
    mainAddPaymentView.addSubview(typeOfPaymentsLabel)
    mainAddPaymentView.addSubview(cashTypeButton)
    cashTypeButton.addSubview(cashTypeButtonTitleLabel)
    mainAddPaymentView.addSubview(cardTypeButton)
    cardTypeButton.addSubview(cardTypeButtonTitleLabel)
    mainAddPaymentView.addSubview(onlineWalletTypeButton)
    onlineWalletTypeButton.addSubview(onlineWalletButtonTitleLabel)
    mainAddPaymentView.addSubview(otherTypeButton)
    otherTypeButton.addSubview(otherButtonTitleLabel)
    addSubview(addPaymentButton)
    addPaymentButton.addSubview(addPaymentButtonTitle)
    
    mainAddPaymentView.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(16)
          make.trailing.leading.equalToSuperview()
          make.height.equalTo(428)
        }
    
    mainAddPaymentView.layer.masksToBounds = true
    mainAddPaymentView.layer.cornerRadius = 20
    
    addPaymentNameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(24)
    }
    
    addPaymentNameLabel.textAlignment = .center
    addPaymentNameLabel.text = "Payment name"
    
    addPaymentNameTextField.snp.makeConstraints { make in
      make.top.equalTo(addPaymentNameLabel.snp.bottom).offset(8)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(36)
    }
    
    addPaymentNameTextField.layer.cornerRadius = 8
    addPaymentNameTextField.layer.opacity = 0.6
    addPaymentNameTextField.textAlignment = .center
    addPaymentNameTextField.hideKeyboardWhenDoneButtonTapped()
    
    startAmountLabel.snp.makeConstraints { make in
      make.top.equalTo(addPaymentNameTextField.snp.bottom).offset(8)
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
    
    startAmountTextField.layer.cornerRadius = 8
    startAmountTextField.layer.opacity = 0.6
    startAmountTextField.textAlignment = .center
    startAmountTextField.placeholder = "0"
    startAmountTextField.keyboardType = .numberPad
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

    cashTypeButton.layer.cornerRadius = 8
    cashTypeButton.layer.borderWidth = 1
    cashTypeButton.addTarget(self, action: #selector(cashButtonIsChosen), for: .touchUpInside)

    cashTypeButtonTitleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    cashTypeButtonTitleLabel.text = "cash"
    cashTypeButtonTitleLabel.textAlignment = .center

    cardTypeButton.snp.makeConstraints { make in
      make.top.equalTo(cashTypeButton.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(40)
    }

    cardTypeButton.layer.cornerRadius = 8
    cardTypeButton.layer.borderWidth = 1
    cardTypeButton.addTarget(self, action: #selector(cardButtonIsChosen), for: .touchUpInside)

    cardTypeButtonTitleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    cardTypeButtonTitleLabel.text = "card"
    cardTypeButtonTitleLabel.textAlignment = .center

    onlineWalletTypeButton.snp.makeConstraints { make in
      make.top.equalTo(cardTypeButton.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(40)
    }

    onlineWalletTypeButton.layer.cornerRadius = 8
    onlineWalletTypeButton.layer.borderWidth = 1
    onlineWalletTypeButton.addTarget(self, action: #selector(onlineWalletButtonIsChosen), for: .touchUpInside)
    
    onlineWalletButtonTitleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    onlineWalletButtonTitleLabel.text = "online wallet"
    onlineWalletButtonTitleLabel.textAlignment = .center

    otherTypeButton.snp.makeConstraints { make in
      make.top.equalTo(onlineWalletTypeButton.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(40)
    }

    otherTypeButton.layer.cornerRadius = 8
    otherTypeButton.layer.borderWidth = 1
    otherTypeButton.addTarget(self, action: #selector(otherButtonIsChosen), for: .touchUpInside)

    otherButtonTitleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    otherButtonTitleLabel.text = "other"
    otherButtonTitleLabel.textAlignment = .center

    addPaymentButton.snp.makeConstraints { make in
      make.top.equalTo(mainAddPaymentView.snp.bottom).offset(16)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(40)
    }

    addPaymentButton.layer.cornerRadius = 20
    addPaymentButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    addPaymentButton.isHidden = true

    addPaymentButtonTitle.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    addPaymentButtonTitle.text = "Create"
    addPaymentButtonTitle.textAlignment = .center
  }
  
}





