//
//  ExpenseService.swift
//  Expenses
//
//  Created by Valentina Vențel on 18.08.2024.
//

import Foundation
import RealmSwift

protocol ExpensesService {
  func addExpense(
    expense: Expense,
    completionHandler: @escaping(Result<Void, Error>) -> ()
  )
  func fetchExpenses() -> [Expense]
}

struct ExpensesServiceImpl: ExpensesService {
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
    guard let image = expense.image else { return }

    saveImageToDisk(
      image: image,
      with: expense.localID
    ) { imageURL in
        guard let imageURL = imageURL else { return }
        var expense = expense
        expense.imageURL = imageURL
        addExpenseToLocalDB(
          expense: expense,
          completionHandler: completionHandler
        )
      }
  }
  
  private func addExpenseToLocalDB(
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
  }

  func fetchExpenses() -> [Expense] {
    let dbExpenses = realmDB.objects(DBExpense.self)
    let expenses: [Expense] = dbExpenses.map {
      Expense(
        title: $0.title,
        date: $0.date,
        price: $0.price,
        currency: $0.currency,
        type: ExpenseType(rawValue: $0.type) ?? .invoice,
        isStoredLocally: $0.isStoredLocally,
        localID: $0.localID,
        id: $0.id.value,
        imageURL: URL(fileURLWithPath: $0.imageURL)
      )
    }

    return expenses
  }
}
