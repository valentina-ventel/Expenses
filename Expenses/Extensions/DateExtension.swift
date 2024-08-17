//
//  DateExtension.swift
//  Expenses
//
//  Created by Valentina Vențel on 15.08.2024.
//
import Foundation

private let dateFormatter = DateFormatter()

extension Date {
  func convertToString_dMHm_format() -> String {
    dateFormatter.dateFormat = "dd MMM, HH:mm"

    return dateFormatter.string(from: self)
  }
  
  func monthString() -> String {
    dateFormatter.dateFormat = "MMMM YYYY"

    return dateFormatter.string(from: self)
  }
}
