//
//  Expense.swift
//  Expenses
//
//  Created by Valentina Vențel on 19.08.2024.
//

import Foundation
import UIKit

public enum ExpenseType: Int, CaseIterable {
  case receipt
  case invoice
  
  var stringValue: String {
    String(describing: self).capitalized
  }
}

struct Expense {
  let id: Int?
  let localID: String
  var title: String
  var date: Date
  var price: Float
  var currency: String
  var type: ExpenseType
  var isStoredLocally: Bool
  var image: UIImage?
  var imageURL: URL
  
  init(
    title: String,
    date: Date,
    price: Float,
    currency: String,
    type: ExpenseType,
    isStoredLocally: Bool,
    localID: String = UUID().uuidString,
    id: Int? = nil,
    image: UIImage? = UIImage(),
    imageURL: URL = URL(fileURLWithPath: "")
  ) {
    self.id = id
    self.localID = localID
    self.title = title
    self.date = date
    self.price = price
    self.currency = currency
    self.type = type
    self.isStoredLocally = isStoredLocally
    self.image = image
    self.imageURL = imageURL
  }
}
