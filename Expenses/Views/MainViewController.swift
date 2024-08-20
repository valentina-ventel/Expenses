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
    static let storyboardID: String = "Main"
    static let expenseViewControllerID = "ExpenseViewController"
    static let fatalErrorMesssage: String = "Failed Expenses Service"
  }

  @IBOutlet private weak var expensesTableView: UITableView?

  var mainViewModel: MainViewModelProtocol?

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    guard let expenseService = appDelegate.expensesService else { fatalError(Constants.fatalErrorMesssage) }
    self.mainViewModel = MainViewModel(service: expenseService)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainViewModel?.fetchExpenses()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    expensesTableView?.register(
      UINib(nibName: Constants.expenseCellIdentifier, bundle: nil),
      forCellReuseIdentifier: Constants.expenseCellIdentifier
    )
    expensesTableView?.register(
      UINib(nibName: Constants.expenseSectionIdentifier, bundle: nil),
      forHeaderFooterViewReuseIdentifier: Constants.expenseSectionIdentifier
    )
    expensesTableView?.showsVerticalScrollIndicator = false
    setupBindings()
  }

  private func setupBindings() {
    mainViewModel?.isLoading.bind() { [weak self] isLoading in
      if (!isLoading && self?.mainViewModel?.numberOfSections != nil) {
        DispatchQueue.main.async {
          self?.expensesTableView?.reloadData()
        }
      }
    }
  }

  private func initExpenseVC() {
    let storyboard = UIStoryboard(name: Constants.storyboardID, bundle: nil)
    guard let expenseVC = storyboard.instantiateViewController(withIdentifier: Constants.expenseViewControllerID) as? ExpenseViewController else { return }
    expenseVC.modalPresentationStyle = .fullScreen
    
    self.present(expenseVC, animated: true, completion: nil)
  }

  @IBAction func goToExpenseVCAction(_ sender: Any) {
    initExpenseVC()
  }

  // MARK: TableView delegates
  func numberOfSections(
    in tableView: UITableView
  ) -> Int {
    mainViewModel?.numberOfSections ?? 0
  }

  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    mainViewModel?.getNumberOfExpenses(for: section) ?? 0
  }

  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    guard let sectionView = tableView.dequeueReusableHeaderFooterView(
      withIdentifier: Constants.expenseSectionIdentifier
    ) as? ExpenseTableViewSection else { return UIView() }
    sectionView.custom(sectionTitle: mainViewModel?.getTitle(for: section) ?? "")

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

    guard let mainViewModelProtocol = mainViewModel else { return UITableViewCell() }
    expenseCell.updateUIWithData(
      expense: mainViewModelProtocol.getExpense(
        at: indexPath.row,
        for: indexPath.section
      )
    )

    return expenseCell
  }

  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return Constants.expenseCellHeight
  }

  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    return Constants.expenseSectionHeight
  }

  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    // TODO: Go to ExpenseVC to load expense details
  }
}
