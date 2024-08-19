//
//  Helpers.swift
//  Expenses
//
//  Created by Valentina Vențel on 16.08.2024.
//

import UIKit

func groupExpensesByMonth(expenses: [Expense]) -> [Date: [Expense]] {
  Dictionary(grouping: expenses) { expense in
    let components = Calendar.current.dateComponents([.year, .month], from: expense.date)
    return Calendar.current.date(from: components)!
  }
}

func customAlertController(
  title: String,
  message: String,
  buttonTitle: String
) -> UIAlertController {
  let alert = UIAlertController(
    title: title,
    message: message,
    preferredStyle: .alert
  )
  alert.addAction(
    UIAlertAction(
      title: buttonTitle,
      style: .cancel,
      handler: nil
    )
  )
  
  return alert
}
