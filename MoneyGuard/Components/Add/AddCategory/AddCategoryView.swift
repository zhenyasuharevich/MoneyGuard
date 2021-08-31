//
//  AddCategoryView.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 29/08/2021.
//

import UIKit

import UIKit

protocol AddCategoryViewDelegate: AnyObject {
  func addCategory(newCategory: Category)
}

class AddCategoryView: UIView {
  
  private let mainAddCategoryView = UIView()
  private let categoryNameLabel = UILabel()
  private let categoryNameTextField = UITextField()
  private let addCategoryButton = UIButton()
  
  private var currentColorTheme: ColorThemeProtocol?
  private var currentTheme: ThemeType?

  weak var delegate: AddCategoryViewDelegate?
  
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
    
    categoryNameLabel.textColor = colorTheme.textColor
    categoryNameTextField.backgroundColor = colorTheme.backgroundColor
    categoryNameTextField.textColor = colorTheme.textColor.withAlphaComponent(0.8)
    categoryNameLabel.tintColor = colorTheme.textColor.withAlphaComponent(0.8)
    
    addCategoryButton.backgroundColor = .none
  }
  
  @objc func dismissKeyboard() {
      endEditing(true)
  }

  @objc func createCategoryPressed(){
    guard let text = categoryNameTextField.text, !text.isEmpty else { print("Error: Can't create category with empty name"); return }
    
    let newCategory = Category(identifier: UUID().uuidString, name: text, amountSpent: Double(0))
    delegate?.addCategory(newCategory: newCategory)
  }
  
}

extension AddCategoryView: UITextFieldDelegate {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { super.touchesBegan(touches, with: event); endEditing(true) }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool { endEditing(true); return true }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = categoryNameTextField.text, !text.isEmpty else {
      addCategoryButton.isEnabled = false
      addCategoryButton.backgroundColor = .none
      return
    }
    addCategoryButton.isEnabled = true
    addCategoryButton.backgroundColor = currentColorTheme?.activeColor
  }

}

extension AddCategoryView {
  private func setupSubview() {
    backgroundColor = .clear
    
    categoryNameTextField.delegate = self
    
    addSubview(mainAddCategoryView)
    mainAddCategoryView.addSubview(categoryNameLabel)
    mainAddCategoryView.addSubview(categoryNameTextField)
    addSubview(addCategoryButton)
    
    mainAddCategoryView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.trailing.leading.equalToSuperview()
      make.height.equalTo(96)
    }
    
    mainAddCategoryView.layer.masksToBounds = true
    mainAddCategoryView.layer.cornerRadius = 20
    
    categoryNameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(24)
    }
    
    categoryNameLabel.textAlignment = .center
    categoryNameLabel.text = "Category name"
    
    categoryNameTextField.snp.makeConstraints { make in
      make.top.equalTo(categoryNameLabel.snp.bottom).offset(8)
      make.trailing.equalToSuperview().offset(-24)
      make.leading.equalToSuperview().offset(24)
      make.height.equalTo(36)
    }
    categoryNameTextField.textAlignment = .center
    categoryNameTextField.layer.cornerRadius = 8
    categoryNameTextField.hideKeyboardWhenDoneButtonTapped()
    
    addCategoryButton.snp.makeConstraints { make in
      make.top.equalTo(mainAddCategoryView.snp.bottom).offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(40)
    }
    addCategoryButton.setTitle("Create", for: .normal)
    addCategoryButton.layer.cornerRadius = 20
    addCategoryButton.layer.borderWidth = 1
    addCategoryButton.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    addCategoryButton.addTarget(self, action: #selector(createCategoryPressed), for: .touchUpInside)
    addCategoryButton.isEnabled = false
  }
}
