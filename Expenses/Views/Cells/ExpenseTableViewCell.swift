//
//  ExpenseTableViewCell.swift
//  Expenses
//
//  Created by Valentina Vențel on 15.08.2024.
//

import UIKit

final class ExpenseTableViewCell: UITableViewCell {
  @IBOutlet private weak var expenseTitleLabel: UILabel!
  @IBOutlet private weak var expenseDateLabel: UILabel!
  @IBOutlet private weak var expenseCurrencyLabel: UILabel!
  @IBOutlet private weak var expensePriceLabel: UILabel!
  
  func updateUIWithData(expense: Expense) {
    expenseTitleLabel.text = expense.title
    expenseDateLabel.text = expense.date.dMHmformatDate()
    expenseCurrencyLabel.text = expense.currency
    expensePriceLabel.text = "\(expense.price)"

  }
}
