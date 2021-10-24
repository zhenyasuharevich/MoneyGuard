//
//  AddTransactionView.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 04.09.2021.
//

import UIKit

protocol AddTransactionViewDelegate: AnyObject {
  func addTransactionWithGetMoneyType(transaction: Transaction, payment: Payment)
  func addTransactionWithSendMoneyType(transaction: Transaction, payment: Payment, category: Category)
  func addTransactionChoosePaymentPressed()
  func addTransactionChooseCategoryPressed()
  func addTransactionShowErrorAlert(title: String, message: String)
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
  
  weak var delegate: AddTransactionViewDelegate?
  
  private var selectedPayment: Payment? = nil {
    didSet {
      updatePaymentButton()
      enableSubmitButtonIfPossible()
    }
  }
  
  private var selectedCategory: Category? = nil {
    didSet {
      updateCategoryButton()
      enableSubmitButtonIfPossible()
    }
  }
  
  private var transactionType: TransactionType {
    didSet {
      configureStackView(for: transactionType)
      transactionTypeLabel.text = getTitle()
    }
  }
  
  private var isSubmitEnable: Bool {
    didSet {
      guard let colorTheme = self.currentColorTheme else { print(#line,#function,"Error: Don't found color theme"); return }
      
      if isSubmitEnable {
        submitButton.backgroundColor = colorTheme.activeColor
        submitButton.isEnabled = true
      } else {
        submitButton.isEnabled = false
        submitButton.backgroundColor = .clear
      }
    }
  }
  
  override init(frame: CGRect) {
    self.isSubmitEnable = false
    self.transactionType = .unowned
    super.init(frame: frame)
    setupSubviews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    
    mainActiveView.backgroundColor = colorTheme.cellBackgroundColor
    submitButton.backgroundColor = .clear
    
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
  
  func setTransactionType(_ transactionType: TransactionType) {
    self.transactionType = transactionType
  }
  
  func getTitle() -> String {
    switch transactionType {
    case .getMoney:
      return "Transfer money to available payment"
    case .sendMoney:
      return "Spend money for category"
    case .unowned:
      return "Error: unknowned transaction type"
    }
  }
  
  
  func setupInitialState() {
    self.amountValueTextField.text = "\(Double(0.0))"
    self.notesTextView.text = ""
    self.transactionType = .unowned
    self.selectedPayment = nil
    self.selectedCategory = nil
  }
  
  private func updatePaymentButton() {
    guard let _selectedPayment = self.selectedPayment else {
      choosePaymentButton.setTitle("Choose Payment", for: .normal)
      return
    }
    choosePaymentButton.setTitle(_selectedPayment.name, for: .normal)
  }
  
  private func updateCategoryButton() {
    guard let _selectedCategory = self.selectedCategory else {
      chooseCategoryButton.setTitle("Choose Category", for: .normal)
      return
    }
    chooseCategoryButton.setTitle(_selectedCategory.name, for: .normal)
  }
  
  @objc private func enableSubmitButtonIfPossible() {
    switch transactionType {
    case .getMoney:
      guard let payment = self.selectedPayment,
            let amountString = amountValueTextField.text,
            !amountString.isEmpty,
            let amountValue = Double(amountString),
            amountValue > 0 else {
        isSubmitEnable = false
        return
      }
      isSubmitEnable = true
    case .sendMoney:
      guard let category = self.selectedCategory,
            let payment = self.selectedPayment,
            let amountString = amountValueTextField.text,
            !amountString.isEmpty,
            let amountValue = Double(amountString),
            amountValue > 0 else {
        isSubmitEnable = false
        return
      }
      isSubmitEnable = true
    default:
      isSubmitEnable = false
    }
  }
  
  @objc private func choosePaymentButtonPressed() {
    delegate?.addTransactionChoosePaymentPressed()
  }
  
  @objc private func chooseCategoryButtonPressed() {
    delegate?.addTransactionChooseCategoryPressed()
  }
  
  @objc private func submitButtonPressed() {
    
    guard let payment = self.selectedPayment,
          let amountString = amountValueTextField.text,
          !amountString.isEmpty,
          let amountValue = Double(amountString),
          amountValue > 0 else { print(#line,#function,"Error: Not enough info to create transaction"); return }
    
    switch transactionType {
    case .sendMoney:
      guard let category = self.selectedCategory else { print(#line,#function,"Error: Can't get category to create transaction with .sendMoney type"); return }
      let transaction = Transaction(identifier: UUID().uuidString, amount: amountValue, type: .sendMoney, date: Date(), paymentName: payment.name, categoryName: category.name, description: self.notesTextView.text)
      
      if payment.amount < transaction.amount {
        delegate?.addTransactionShowErrorAlert(title: "Insufficient funds", message: "You haven't enough money on payment: \(payment.name) to add transaction. Enter another value to add transaction.")
      } else {
        payment.amount -= transaction.amount
        category.amountSpent += transaction.amount
        delegate?.addTransactionWithSendMoneyType(transaction: transaction, payment: payment, category: category)
      }
      
    case .getMoney:
      let transaction = Transaction(identifier: UUID().uuidString, amount: amountValue, type: .getMoney, date: Date(), paymentName: payment.name, categoryName: nil, description: self.notesTextView.text)
      
      payment.amount += transaction.amount
      
      delegate?.addTransactionWithGetMoneyType(transaction: transaction, payment: payment)
    case .unowned:
      delegate?.addTransactionShowErrorAlert(title: "Error", message: "Unowned transaction type. Please try againg...")
    }
    
    
//    delegate?.addTransactionSubmit()
  }
  
  func setPayment(payment: Payment) {
    self.selectedPayment = payment
  }
  
  func setCategory(category: Category) {
    self.selectedCategory = category
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
    
    choosePaymentView.addSubview(choosePaymentLabel)
    choosePaymentView.addSubview(choosePaymentButton)
    choosePaymentView.backgroundColor = .clear
    
    chooseCategoryView.addSubview(chooseCategoryLabel)
    chooseCategoryView.addSubview(chooseCategoryButton)
    chooseCategoryView.backgroundColor = .clear
    
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
    submitButton.isEnabled = false
    
    transactionTypeLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().offset(-8)
      make.height.equalTo(24)
    }
    transactionTypeLabel.font = .systemFont(ofSize: 18, weight: .medium)
    transactionTypeLabel.textAlignment = .center
    transactionTypeLabel.text = getTitle()
    
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
    amountValueTextField.keyboardType = .decimalPad
    amountValueTextField.text = "\(Double(0.0))"
    amountValueTextField.textAlignment = .center
    amountValueTextField.layer.cornerRadius = 8
    amountValueTextField.hideKeyboardWhenDoneButtonTapped()
    amountValueTextField.addTarget(self, action: #selector(enableSubmitButtonIfPossible), for: .editingChanged)
    
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
    choosePaymentButton.addTarget(self, action: #selector(choosePaymentButtonPressed), for: .touchUpInside)
    
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
      make.top.equalTo(chooseCategoryLabel.snp.bottom).offset(8)
      make.bottom.equalToSuperview()
    }
    chooseCategoryButton.setTitle("Choose Category", for: .normal)
    chooseCategoryButton.layer.cornerRadius = 8
    chooseCategoryButton.clipsToBounds = true
    chooseCategoryButton.addTarget(self, action: #selector(chooseCategoryButtonPressed), for: .touchUpInside)
    
    configureStackView(for: self.transactionType)
  }
  
  private func configureStackView(for transactionType: TransactionType) {
    for subview in chooseStackView.arrangedSubviews {
      chooseStackView.removeArrangedSubview(subview)
      subview.removeFromSuperview()
    }
    
    switch transactionType {
    case .getMoney:
      chooseStackView.addArrangedSubview(choosePaymentView)
    case .sendMoney:
      chooseStackView.addArrangedSubview(choosePaymentView)
      chooseStackView.addArrangedSubview(chooseCategoryView)
    case .unowned:
      return
    }
  }
}
