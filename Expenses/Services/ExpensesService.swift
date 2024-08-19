//
//  ExpenseService.swift
//  Expenses
//
//  Created by Valentina Vențel on 18.08.2024.
//

import Foundation
import RealmSwift

protocol ExpenseServiceProtocol {
  func addExpense(
    expense: Expense,
    completionHandler: @escaping(Result<Void, Error>) -> ()
  )
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
  
  func addExpense(
    expense: Expense,
    completionHandler: @escaping(Result<Void, Error>) -> ()
  ) {
    let dbExpense = DBExpense(expense: expense)
    do {
      try realmDB.write() {
        realmDB.add(dbExpense)
      }
      completionHandler(.success(()))
    } catch {
      completionHandler(.failure(error))
    }
    getAllExpenses()
  }
  
  func getAllExpenses() {
    let expenses = realmDB.objects(DBExpense.self)
    
    // Do something with the fetched data
    for expense in expenses {
      print(expense.imageData)
      print("Expense Title: \(expense.title), Value: \(expense.price)")
    }
    print("---------------")
    print("Number of all expenses: \(expenses.count)")
  }
}
