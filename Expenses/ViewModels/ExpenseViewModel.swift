//
//  ExpenseViewModel.swift
//  Expenses
//
//  Created by Valentina Vențel on 18.08.2024.
//

import Foundation

protocol ExpenseViewModelProtocol {
  var isLoading: Observable<Bool> { get }
  func addExpense(
    title: String,
    date: Date,
    price: Float,
    currency: String,
    type: ExpenseType
  )
}

final class ExpenseViewModel: ExpenseViewModelProtocol {
  private var expensesService: ExpensesService
  var isLoading: Observable<Bool> = Observable(false)
  var expenseTitle: String?

  init(service: ExpensesService) {
    self.expensesService = service
  }

  func addExpense(
    title: String,
    date: Date,
    price: Float,
    currency: String,
    type: ExpenseType
  ) {
    let expense = DBExpense(
      title: title,
      date: date,
      price: price,
      currency: currency,
      type: type,
      isStoredLocally: true
    )
    expensesService.addExpense(expense: expense)
  }
}
