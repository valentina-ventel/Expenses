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
  var expense: Expense? { get set }
  var title: String { get }
  var date: Date { get }
  var price: Float { get }
  var currency: String { get }
  var type: ExpenseType { get }
  var image: UIImage { get }
  var isEditingContent: Bool { get }

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
  private enum Constants {
    static let defaultCurrency: String = "RON"
    static let imagePlaceholderName: String = "camera"
  }

  private var expensesService: ExpensesService
  var isLoading: Observable<Bool> = Observable(false)
  var expenseWasAddedSuccessfully: Observable<Bool> = Observable(false)
  var errorObservable: Observable<String> = Observable("")
  var expense: Expense?

  var title: String {
    get {
      guard let expense = expense else { return "" }
      return expense.title
    }
  }

  var date: Date {
    get {
      guard let expense = expense else { return Date.now }
      return expense.date
    }
  }

  var price: Float {
    get {
      guard let expense = expense else { return .zero }
      return expense.price
    }
  }

  var currency: String {
    get {
      guard let expense = expense else { return Constants.defaultCurrency }
      return expense.currency
    }
  }

  var type: ExpenseType {
    get {
      guard let expense = expense else { return ExpenseType.receipt }
      return expense.type
    }
  }

  var image: UIImage {
    get {
      guard let expense = expense else {
        return UIImage(systemName: Constants.imagePlaceholderName) ?? UIImage()
      }
      guard let imageData = try? Data(contentsOf: expense.imageURL),
            let image = UIImage(data: imageData) else {
        return UIImage()
      }
      return image
    }
  }

  var isEditingContent: Bool {
    get { expense == nil }
  }

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
