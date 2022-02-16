//
//  Date+Extension.swift
//  MoneyGuard
//
//  Created by Дмитрий Лещёв on 16/02/2022.
//

import Foundation

extension Date {
  func dayOfWeek() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter.string(from: self).capitalized
  }
  
  func monthOfYear() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    return dateFormatter.string(from: self).capitalized
  }
  
}
