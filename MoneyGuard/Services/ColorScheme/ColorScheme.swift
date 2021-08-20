//
//  ColorScheme.swift
//  onestat
//
//  Created by Zhenya Suharevich on 06.05.2021.
//

import UIKit

enum ThemeType: String, Codable {
  case dark
  case light
  case system
}

protocol ColorThemeProtocol {
  var backgroundColor: UIColor { get set }
  var cellBackgroundColor: UIColor { get set }
  var textColor: UIColor { get set }
  var formBackgroundColor: UIColor { get set }
  var activeColor: UIColor { get set }
}

struct LightColorTheme: ColorThemeProtocol {
  var backgroundColor: UIColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1) //#E5E5E5
  var cellBackgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //#FFFFFF
  var textColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //#000000
  var formBackgroundColor: UIColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1) //#C9C9C9
  var activeColor: UIColor = #colorLiteral(red: 0.8549019608, green: 0.2274509804, blue: 0.2274509804, alpha: 1) //#DA3A3A
}

struct DarkColorTheme: ColorThemeProtocol {
  var backgroundColor: UIColor = #colorLiteral(red: 0.05098039216, green: 0.09019607843, blue: 0.1921568627, alpha: 1) //#0D1731
  var cellBackgroundColor: UIColor = #colorLiteral(red: 0.1019607843, green: 0.1529411765, blue: 0.2941176471, alpha: 1) //#1A274B
  var textColor: UIColor = #colorLiteral(red: 0.9450980392, green: 0.9333333333, blue: 0.9019607843, alpha: 1) //#F1EEE6
  var formBackgroundColor: UIColor = #colorLiteral(red: 0.07058823529, green: 0.1137254902, blue: 0.2470588235, alpha: 1) //#121D3F
  var activeColor: UIColor = #colorLiteral(red: 0.09803921569, green: 0.3058823529, blue: 0.6, alpha: 1) //#194E99
}
