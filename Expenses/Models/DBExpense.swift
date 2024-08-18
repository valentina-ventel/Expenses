//
//  DBExpense.swift
//  Expenses
//
//  Created by Valentina Vențel on 15.08.2024.
//

import Foundation
import RealmSwift

public enum ExpenseType: CaseIterable {
  case receipt
  case invoice
  
  var stringValue: String {
    String(describing: self).capitalized
  }
}

class DBExpense: Object {
  var id = RealmProperty<Int?>()
  @objc dynamic var localID: String = UUID().uuidString
  @objc dynamic var title: String = ""
  @objc dynamic var date: Date = Date.now
  @objc dynamic var price: Float = 0.0
  @objc dynamic var currency: String = ""
  @objc dynamic var type: String = ""
  @objc dynamic var isStoredLocally: Bool = false
  
  override class func primaryKey() -> String? { "localID" }

  override init() {
    super.init()
  }

  required init(
    title: String,
    date: Date,
    price: Float,
    currency: String,
    type: ExpenseType,
    isStoredLocally: Bool,
    id: Int? = nil
  ) {
    self.id.value = id
    self.title = title
    self.date = date
    self.price = price
    self.currency = currency
    self.type = type.stringValue
    self.isStoredLocally = isStoredLocally
  }
}

var dummyExpenses: [DBExpense] {
  [
    DBExpense(title: "Visma", date: Date.now, price: 2000, currency: "RON", type: .invoice, isStoredLocally: true),
    DBExpense(title: "eMag", date: Date.now, price: 3500, currency: "RON", type: .receipt, isStoredLocally: false),
    DBExpense(title: "Mega image", date: Date.now, price: 200, currency: "RON", type: .invoice, isStoredLocally: false),
    DBExpense(title: "Vivo", date: Date.now, price: 350, currency: "RON", type: .receipt, isStoredLocally: false),
    DBExpense(title: "Zara", date: Date.now, price: 200, currency: "RON", type: .invoice, isStoredLocally: true),
    DBExpense(title: "H&M", date: Date.now, price: 500, currency: "RON", type: .receipt, isStoredLocally: true),
    DBExpense(title: "Lidl", date: Date.now, price: 100, currency: "RON", type: .invoice, isStoredLocally: false),
    DBExpense(title: "Auchan", date: Date.now, price: 300, currency: "RON", type: .receipt, isStoredLocally: false),
    DBExpense(title: "Dyson", date: Date.now, price: 4000, currency: "RON", type: .invoice, isStoredLocally: false),
    DBExpense(title: "iStyle", date: Date.now, price: 6400, currency: "RON", type: .receipt, isStoredLocally: true),
    DBExpense(title: "Mega image", date: Date(timeIntervalSince1970: 1705415794), price: 200, currency: "RON", type: .invoice, isStoredLocally: true),
    DBExpense(title: "Vivo", date: Date(timeIntervalSince1970: 1706106994), price: 350, currency: "RON", type: .receipt, isStoredLocally: false),
    DBExpense(title: "Zara", date: Date(timeIntervalSince1970: 1674570994), price: 200, currency: "RON", type: .invoice, isStoredLocally: false),
    DBExpense(title: "Visma", date: Date(timeIntervalSince1970: 1432233446145.0/1000.0), price: 2000, currency: "RON", type: .invoice, isStoredLocally: false),
    DBExpense(title: "eMag", date: Date(timeIntervalSince1970: 1431024488), price: 3500, currency: "RON", type: .receipt, isStoredLocally: false)
  ]
}
