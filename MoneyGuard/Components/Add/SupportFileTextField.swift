//
//  SupportTextField.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 29/08/2021.
//

import Foundation

extension UITextField {
  func hideKeyboardWhenDoneButtonTapped () {
    let keyboardToolbar = UIToolbar()
    self.inputAccessoryView = keyboardToolbar
    keyboardToolbar.sizeToFit()

    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard) )

    keyboardToolbar.items = [flexSpace, doneButton]
  }

  @objc func dismissKeyboard() {
    endEditing(true)
  }

}

extension UITextView {
  func hideKeyboardWhenDoneButtonTapped () {
    let keyboardToolbar = UIToolbar()
    self.inputAccessoryView = keyboardToolbar
    keyboardToolbar.sizeToFit()

    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard) )

    keyboardToolbar.items = [flexSpace, doneButton]
  }

  @objc func dismissKeyboard() {
    endEditing(true)
  }

}
