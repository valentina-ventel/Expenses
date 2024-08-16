//
//  Expense.swift
//  Expenses
//
//  Created by Valentina Vențel on 15.08.2024.
//

import UIKit

public enum ExpensesTypes: String {
  case receipts
  case invoices
}

struct Expense {
  var id: Int
  var title: String
  var date: Date
  var price: Float
  var currency: String
  var type: ExpensesTypes
  
  init(
    id: Int,
    title: String,
    date: Date,
    price: Float,
    currency: String,
    type: ExpensesTypes
  ) {
    self.id = id
    self.title = title
    self.date = date
    self.price = price
    self.currency = currency
    self.type = type
  }

  static var dummyExpenses: [Expense] {
    [
      Expense(id: 0, title: "Visma", date: Date.now, price: 2000, currency: "RON", type: .invoices),
      Expense(id: 1, title: "eMag", date: Date.now, price: 3500, currency: "RON", type: .receipts),
      Expense(id: 2, title: "Mega image", date: Date.now, price: 200, currency: "RON", type: .invoices),
      Expense(id: 3, title: "Vivo", date: Date.now, price: 350, currency: "RON", type: .receipts),
      Expense(id: 4, title: "Zara", date: Date.now, price: 200, currency: "RON", type: .invoices),
      Expense(id: 5, title: "H&M", date: Date.now, price: 500, currency: "RON", type: .receipts),
      Expense(id: 6, title: "Lidl", date: Date.now, price: 100, currency: "RON", type: .invoices),
      Expense(id: 7, title: "Auchan", date: Date.now, price: 300, currency: "RON", type: .receipts),
      Expense(id: 8, title: "Dyson", date: Date.now, price: 4000, currency: "RON", type: .invoices),
      Expense(id: 9, title: "iStyle", date: Date.now, price: 6400, currency: "RON", type: .receipts)
    ]
  }
}

