//
//  MainViewModel.swift
//  Expenses
//
//  Created by Valentina Vențel on 19.08.2024.
//

import Foundation

protocol MainViewModelProtocol {
  var isLoading: Observable<Bool> { get }
  var numberOfSections: Int { get }
  func fetchExpenses()
  func getNumberOfExpenses(for section: Int) -> Int
  func getTitle(for section: Int) -> String
  func getExpense(at index: Int, for section: Int) -> Expense
}

final class MainViewModel: MainViewModelProtocol {
  var isLoading: Observable<Bool> = Observable(false)
  var numberOfSections: Int {
    guard let expensesDictionary = expensesDictionary else { return 0 }
    return expensesDictionary.keys.count
  }

  private var expensesService: ExpensesServiceProtocol
  private var expensesDictionary: [Date : [Expense]]?
  private var expensesMonthsArray: [Date]?

  required init(service: ExpensesServiceProtocol) {
    self.expensesService = service
  }

  func fetchExpenses() {
    isLoading.value = true
    let expenses = expensesService.fetchExpenses()
    expensesDictionary = groupExpensesByMonth(expenses: expenses)
    expensesMonthsArray = expensesDictionary?.keys.sorted { $0 > $1 }
    isLoading.value = false
  }

  func getNumberOfExpenses(for section: Int) -> Int {
    guard let expensesMonthsArray = expensesMonthsArray else { return 0 }
    let key = expensesMonthsArray[section]
    return expensesDictionary?[key]?.count ?? 0
  }

  func getTitle(for section: Int) -> String {
    guard let expensesMonthsArray = expensesMonthsArray else { return "" }
    return expensesMonthsArray[section].monthString()
  }

  func getExpense(at index: Int, for section: Int) -> Expense {
    let monthKey = expensesMonthsArray?[section] ?? Date.now
    let monthExpenses = expensesDictionary?[monthKey]
    return monthExpenses![index]
  }
}
