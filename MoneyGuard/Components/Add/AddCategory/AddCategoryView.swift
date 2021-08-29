//
//  AddCategoryView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 29/08/2021.
//

import UIKit

import UIKit

class AddCategoryView: UIView {
  
  private let mainAddCategoryView = UIView()
  private let addCategoryNameLabel = UILabel()
  private let addCategoryNameTextField = UITextField()
  private let addCategoryNameButton = UIButton()
  private let addCategoryNameButtonTitle = UILabel()
  
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
    
    mainAddCategoryView.backgroundColor = colorTheme.cellBackgroundColor
    addCategoryNameLabel.textColor = colorTheme.textColor
    addCategoryNameTextField.backgroundColor = colorTheme.backgroundColor
    addCategoryNameButton.backgroundColor = colorTheme.activeColor
    addCategoryNameButtonTitle.textColor = colorTheme.textColor
  }
  
  @objc func dismissKeyboard() {
      endEditing(true)
  }

  @objc func buttonTapped(){
    print("Adding new category...")
  }
  
}

extension AddCategoryView: UITextFieldDelegate {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      endEditing(true) // Скрывает клавиатуру, вызванную для любого объекта
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {  //func to hide keyboard, when button "return" is tapped
    endEditing(true)
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) { // func to hide button, when textfield is empty
    if addCategoryNameTextField.text == "" {
      addCategoryNameButton.isHidden = true
    }
    else {
      addCategoryNameButton.isHidden = false
    }
  }

}

extension AddCategoryView {
  private func setupSubview() {
    backgroundColor = .clear
    
    addCategoryNameTextField.delegate = self
    
    addSubview(mainAddCategoryView)
    mainAddCategoryView.addSubview(addCategoryNameLabel)
    mainAddCategoryView.addSubview(addCategoryNameTextField)
    addSubview(addCategoryNameButton)
    addCategoryNameButton.addSubview(addCategoryNameButtonTitle)
    
    mainAddCategoryView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(96)
    }
    
    mainAddCategoryView.layer.masksToBounds = true
    mainAddCategoryView.layer.cornerRadius = 20
    
    addCategoryNameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(24)
    }
    
    addCategoryNameLabel.textAlignment = .center
    addCategoryNameLabel.text = "Category name"
    
    addCategoryNameTextField.snp.makeConstraints { make in
      make.top.equalTo(addCategoryNameLabel.snp.bottom).offset(8)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(36)
    }
    
    addCategoryNameTextField.layer.cornerRadius = 8
    addCategoryNameTextField.layer.opacity = 0.6
    addCategoryNameTextField.hideKeyboardWhenDoneButtonTapped()
    
    addCategoryNameButton.snp.makeConstraints { make in
      make.top.equalTo(mainAddCategoryView.snp.bottom).offset(16)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(40)
    }
    
    addCategoryNameButton.layer.cornerRadius = 20
    addCategoryNameButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    addCategoryNameButton.isHidden = true
    
    addCategoryNameButtonTitle.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    addCategoryNameButtonTitle.text = "Create"
    addCategoryNameButtonTitle.textAlignment = .center
  }
}
