//
//  SettingsController.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 21.09.2021.
//

import UIKit

protocol SettingsControllerDelegate: AnyObject {
  func settingsClearAllData()
  func settingsChangeTheme(_ newTheme: ThemeType)
}

final class SettingsController: UIViewController {
  
  private let topBar = TopBar(title: "Settings")
  
  private let colorThemeLabel = UILabel()
  private let lightThemeButton = UIButton()
  private let darkThemeButton = UIButton()
  private let systemThemeButton = UIButton()
  
  weak var delegate: SettingsControllerDelegate?
  
  private var currentTheme: ThemeType?
  private var currentColorTheme: ColorThemeProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
  }
  
  func setupColorTheme(_ colorTheme: ColorThemeProtocol, _ theme: ThemeType) {
    self.currentColorTheme = colorTheme
    self.currentTheme = theme
    
    topBar.setupColorTheme(colorTheme, theme)
    view.backgroundColor = colorTheme.backgroundColor
    colorThemeLabel.textColor = colorTheme.textColor
    
    deselectButtons(colorTheme: colorTheme)
    selectButton(colorTheme: colorTheme, theme: theme)
  }
  
  func deselectButtons(colorTheme: ColorThemeProtocol) {
    lightThemeButton.backgroundColor = colorTheme.cellBackgroundColor
    lightThemeButton.setTitleColor(colorTheme.textColor, for: .normal)
    
    darkThemeButton.backgroundColor = colorTheme.cellBackgroundColor
    darkThemeButton.setTitleColor(colorTheme.textColor, for: .normal)
    
    systemThemeButton.backgroundColor = colorTheme.cellBackgroundColor
    systemThemeButton.setTitleColor(colorTheme.textColor, for: .normal)
  }
  
  func selectButton(colorTheme: ColorThemeProtocol, theme: ThemeType) {
    var currentButton: UIButton?
    
    switch theme {
    case .dark:
      currentButton = darkThemeButton
    case .light:
      currentButton = lightThemeButton
    case .system:
      currentButton = systemThemeButton
    }
    
    guard let button = currentButton else { return }
    button.backgroundColor = colorTheme.activeColor
    button.setTitleColor(.white, for: .normal)
  }
  
  @objc private func buttonPressed(_ sender: UIButton) {
    if sender == self.lightThemeButton {
      delegate?.settingsChangeTheme(.light)
    } else if sender == self.darkThemeButton {
      delegate?.settingsChangeTheme(.dark)
    } else if sender == self.systemThemeButton {
      delegate?.settingsChangeTheme(.system)
    } else {
      print("Error")
    }
  }
  
}

extension SettingsController {
  
  private func setupSubviews() {
    let buttonsStackView = UIStackView()
    
    view.addSubview(topBar)
    view.addSubview(buttonsStackView)
    view.addSubview(colorThemeLabel)
    
    topBar.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(DashboardConstants.TopBar.height)
    }
    topBar.layer.cornerRadius = 20
    topBar.layer.masksToBounds = true
    topBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    topBar.delegate = self
    
    colorThemeLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalTo(topBar.snp.bottom).offset(20)
    }
    colorThemeLabel.text = "Choose color scheme:"
    colorThemeLabel.textAlignment = .left
    colorThemeLabel.font = .systemFont(ofSize: 16, weight: .regular)
    
    let stackSpacing: CGFloat = 16
    
    buttonsStackView.snp.makeConstraints { make in
      let leadingTrailingTopOffset: CGFloat = 16
      
      make.leading.equalToSuperview().offset(leadingTrailingTopOffset)
      make.trailing.equalToSuperview().offset(-leadingTrailingTopOffset)
      make.top.equalTo(colorThemeLabel.snp.bottom).offset(leadingTrailingTopOffset)
      make.height.equalTo((UIScreen.main.bounds.width - 2 * leadingTrailingTopOffset - 2 * stackSpacing)/3)
    }
    buttonsStackView.axis = .horizontal
    buttonsStackView.distribution = .fillEqually
    buttonsStackView.spacing = stackSpacing
    
    lightThemeButton.layer.cornerRadius = 16
    lightThemeButton.clipsToBounds = true
    lightThemeButton.setTitle("Light", for: .normal)
    lightThemeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    
    darkThemeButton.layer.cornerRadius = 16
    darkThemeButton.clipsToBounds = true
    darkThemeButton.setTitle("Dark", for: .normal)
    darkThemeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    
    systemThemeButton.layer.cornerRadius = 16
    systemThemeButton.clipsToBounds = true
    systemThemeButton.setTitle("System", for: .normal)
    systemThemeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    
    buttonsStackView.addArrangedSubview(lightThemeButton)
    buttonsStackView.addArrangedSubview(darkThemeButton)
    buttonsStackView.addArrangedSubview(systemThemeButton)
  }
  
}

extension SettingsController: TopBarDelegate {
  func returnButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
}
