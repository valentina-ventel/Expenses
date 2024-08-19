//
//  DBExpense.swift
//  Expenses
//
//  Created by Valentina Vențel on 15.08.2024.
//

import Foundation
import RealmSwift

class DBExpense: Object {
  var id = RealmProperty<Int?>()
  @objc dynamic var localID: String = ""
  @objc dynamic var title: String = ""
  @objc dynamic var date: Date = Date.now
  @objc dynamic var price: Float = 0.0
  @objc dynamic var currency: String = ""
  @objc dynamic var type: String = ""
  @objc dynamic var isStoredLocally: Bool = false
  @objc dynamic var imageData: Data?
  
  override class func primaryKey() -> String? { "localID" }

  override init() {
    super.init()
  }

  required init(
    expense: Expense
  ) {
    self.id.value = expense.id
    self.localID = expense.localID
    self.title = expense.title
    self.date = expense.date
    self.price = expense.price
    self.currency = expense.currency
    self.type = expense.type.stringValue
    self.isStoredLocally = expense.isStoredLocally
    self.imageData = expense.image?.jpegData(compressionQuality: 1.0)
  }
}
