//
//  MainViewController.swift
//  Expenses
//
//  Created by Valentina Vențel on 15.08.2024.
//

import UIKit

final class ExpencesHistoryViewController:
  UIViewController,
  UITableViewDataSource,
  UITableViewDelegate
{
  private enum Constants {
    static let expenseCellHeight: CGFloat = 60
    static let expenseCellNibName: String = "ExpenseTableViewCell"
    static let expenseCellIdentifier: String = "ExpenseTableViewCell"
  }

  @IBOutlet private weak var expencesTableView: UITableView?

  override func viewDidLoad() {
    super.viewDidLoad()
    expencesTableView?.register(
      UINib(nibName: Constants.expenseCellNibName,
      bundle: nil),
      forCellReuseIdentifier: Constants.expenseCellIdentifier
    )
  }
  
  // MARK: TableView delegates
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    Expense.dummyExpenses.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let expenseCell = tableView.dequeueReusableCell(
      withIdentifier: Constants.expenseCellIdentifier,
      for: indexPath
    ) as? ExpenseTableViewCell else { return UITableViewCell() }
    expenseCell.updateUIWithData(expense: Expense.dummyExpenses[indexPath.row])
    return expenseCell
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return Constants.expenseCellHeight
  }
}
