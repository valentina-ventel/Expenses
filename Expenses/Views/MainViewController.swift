//
//  MainViewController.swift
//  Expenses
//
//  Created by Valentina Vențel on 15.08.2024.
//

import UIKit

final class MainViewController:
  UIViewController,
  UITableViewDataSource,
  UITableViewDelegate
{
  private enum Constants {
    static let expenseCellHeight: CGFloat = 60
    static let expenseSectionHeight: CGFloat = 48
    static let expenseCellIdentifier: String = "ExpenseTableViewCell"
    static let expenseSectionIdentifier: String = "ExpenseTableViewSection"
    static let expenseSegueIdentifier: String = "showExpenseSegue"
  }

  @IBOutlet private weak var expencesTableView: UITableView?

  private var expensesLocalService: ExpensesService?
  private var expensesDictionary = [Date: [Expense]] ()
  private var expensesMonths = [Date]()

  override func viewDidLoad() {
    super.viewDidLoad()

    expencesTableView?.register(
      UINib(nibName: Constants.expenseCellIdentifier, bundle: nil),
      forCellReuseIdentifier: Constants.expenseCellIdentifier
    )
    expencesTableView?.register(
      UINib(nibName: Constants.expenseSectionIdentifier, bundle: nil),
      forHeaderFooterViewReuseIdentifier: Constants.expenseSectionIdentifier
    )
    expencesTableView?.showsVerticalScrollIndicator = false

    expensesDictionary = groupExpensesByMonth(expenses: dummyExpenses)
    expensesMonths = expensesDictionary.keys.sorted {$0 > $1}
  }
  
  // MARK: TableView delegates
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    let key = expensesMonths[section]
    return expensesDictionary[key]?.count ?? 0
  }
  
  func numberOfSections(
    in tableView: UITableView
  ) -> Int {
    expensesMonths.count
  }

  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    guard let sectionView = tableView.dequeueReusableHeaderFooterView(
      withIdentifier: Constants.expenseSectionIdentifier
    ) as? ExpenseTableViewSection else { return UIView() }
    sectionView.custom(sectionTitle: expensesMonths[section].monthString())

    return sectionView
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let expenseCell = tableView.dequeueReusableCell(
      withIdentifier: Constants.expenseCellIdentifier,
      for: indexPath
    ) as? ExpenseTableViewCell else { return UITableViewCell() }
    
    let monthKey = expensesMonths[indexPath.section]
    guard let expenses = expensesDictionary[monthKey] else { return UITableViewCell() }
    expenseCell.updateUIWithData(expense: expenses[indexPath.row])

    return expenseCell
  }

  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return Constants.expenseCellHeight
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Constants.expenseSectionHeight
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: Constants.expenseSegueIdentifier, sender: nil)
  }
}
