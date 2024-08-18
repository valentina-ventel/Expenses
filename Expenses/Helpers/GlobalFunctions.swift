//
//  Helpers.swift
//  Expenses
//
//  Created by Valentina Vențel on 16.08.2024.
//

import Foundation

func groupExpensesByMonth(expenses: [DBExpense]) -> [Date: [DBExpense]] {
  Dictionary(grouping: expenses) { expense in
    let components = Calendar.current.dateComponents([.year, .month], from: expense.date)
    return Calendar.current.date(from: components)!
  }
}
