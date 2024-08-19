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
  
  init(
    title: String,
    date: Date,
    price: Float,
    currency: String,
    type: ExpenseType,
    isStoredLocally: Bool,
    localID: String = UUID().uuidString,
    id: Int? = nil,
    expenseImage: UIImage? = nil
  ) {
    self.id = id
    self.localID = localID
    self.title = title
    self.date = date
    self.price = price
    self.currency = currency
    self.type = type
    self.isStoredLocally = isStoredLocally
    self.image = expenseImage
  }
}

var dummyExpenses: [Expense] {
  [
    Expense(title: "Visma", date: Date.now, price: 2000, currency: "RON", type: .invoice, isStoredLocally: true),
    Expense(title: "eMag", date: Date.now, price: 3500, currency: "RON", type: .receipt, isStoredLocally: false),
    Expense(title: "Mega image", date: Date.now, price: 200, currency: "RON", type: .invoice, isStoredLocally: false),
    Expense(title: "Vivo", date: Date.now, price: 350, currency: "RON", type: .receipt, isStoredLocally: false),
    Expense(title: "Zara", date: Date.now, price: 200, currency: "RON", type: .invoice, isStoredLocally: true),
    Expense(title: "H&M", date: Date.now, price: 500, currency: "RON", type: .receipt, isStoredLocally: true),
    Expense(title: "Lidl", date: Date.now, price: 100, currency: "RON", type: .invoice, isStoredLocally: false),
    Expense(title: "Auchan", date: Date.now, price: 300, currency: "RON", type: .receipt, isStoredLocally: false),
    Expense(title: "Dyson", date: Date.now, price: 4000, currency: "RON", type: .invoice, isStoredLocally: false),
    Expense(title: "iStyle", date: Date.now, price: 6400, currency: "RON", type: .receipt, isStoredLocally: true),
    Expense(title: "Mega image", date: Date(timeIntervalSince1970: 1705415794), price: 200, currency: "RON", type: .invoice, isStoredLocally: true),
    Expense(title: "Vivo", date: Date(timeIntervalSince1970: 1706106994), price: 350, currency: "RON", type: .receipt, isStoredLocally: false),
    Expense(title: "Zara", date: Date(timeIntervalSince1970: 1674570994), price: 200, currency: "RON", type: .invoice, isStoredLocally: false),
    Expense(title: "Visma", date: Date(timeIntervalSince1970: 1432233446145.0/1000.0), price: 2000, currency: "RON", type: .invoice, isStoredLocally: false),
    Expense(title: "eMag", date: Date(timeIntervalSince1970: 1431024488), price: 3500, currency: "RON", type: .receipt, isStoredLocally: false)
  ]
}
