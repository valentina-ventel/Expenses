//
//  ExpenseViewModel.swift
//  Expenses
//
//  Created by Valentina Vențel on 18.08.2024.
//

import Foundation
import UIKit

protocol ExpenseViewModel {
  var isLoading: Observable<Bool> { get }
  var expenseWasAddedSuccessfully: Observable<Bool> { get }
  var errorObservable: Observable<String> { get }
  func addExpense(
    expenseImage: UIImage,
    title: String,
    date: Date,
    price: Float,
    currency: String,
    type: ExpenseType
  )
}

final class ExpenseViewModelImpl: ExpenseViewModel {
  private var expensesService: ExpensesService
  var isLoading: Observable<Bool> = Observable(false)
  var expenseWasAddedSuccessfully: Observable<Bool> = Observable(false)
  var errorObservable: Observable<String> = Observable("")

  init(service: ExpensesService) {
    self.expensesService = service
  }

  func addExpense(
    expenseImage: UIImage,
    title: String,
    date: Date,
    price: Float,
    currency: String,
    type: ExpenseType
  ) {
    isLoading.value.toggle()
    let expense = Expense(
      title: title,
      date: date,
      price: price,
      currency: currency,
      type: type,
      isStoredLocally: true,
      image: expenseImage
    )
    expensesService.addExpense(expense: expense) { result in
      self.isLoading.value.toggle()

      switch result {
      case .success():
        self.expenseWasAddedSuccessfully.value = true
      case .failure(let error):
        self.errorObservable.value = error.localizedDescription
      }
    }
  }
}
