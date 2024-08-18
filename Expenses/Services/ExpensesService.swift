//
//  ExpenseService.swift
//  Expenses
//
//  Created by Valentina Vențel on 18.08.2024.
//

import Foundation
import RealmSwift

protocol ExpenseServiceProtocol {
  func addExpense(expense: DBExpense)
  func getAllExpenses()
}

struct ExpensesService: ExpenseServiceProtocol {
  private var realmDB: Realm
  
  init?() {
    do {
      realmDB = try Realm()
    } catch {
      return nil
    }
  }
  
  func addExpense(expense: DBExpense) {
    do {
      try realmDB.write() {
        realmDB.add(expense)
      }
    } catch {
      print(error)
    }
    getAllExpenses()
  }
  
  func getAllExpenses() {
    let expenses = realmDB.objects(DBExpense.self)
    
    // Do something with the fetched data
    for expense in expenses {
      print("Expense Title: \(expense.title), Value: \(expense.price)")
    }
    print("---------------")
    print("Number of all expenses: \(expenses.count)")
  }
}
