//
//  DateExtension.swift
//  Expenses
//
//  Created by Valentina Vențel on 15.08.2024.
//

import UIKit

extension Date {
  func dMHmformatDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM, HH:mm"
    return dateFormatter.string(from: self)
  }
}
