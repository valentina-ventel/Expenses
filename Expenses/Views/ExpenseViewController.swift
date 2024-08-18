//
//  ExpenseDetailsViewController.swift
//  Expenses
//
//  Created by Valentina Vențel on 14.08.2024.
//

import UIKit

final class ExpenseViewController:
  UIViewController,
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate,
  UITextFieldDelegate,
  UIPickerViewDelegate,
  UIPickerViewDataSource
{
  private enum Constants {
    static let pickerViewComponentsNumber: Int = 1
  }

  @IBOutlet private weak var expenseImageView: UIImageView!
  @IBOutlet private weak var expenseTitleTextField: UITextField!
  @IBOutlet private weak var expensePriceTextField: UITextField!
  @IBOutlet private weak var expenseTypePicker: UIPickerView!
  @IBOutlet private weak var expenseDatePicker: UIDatePicker!
  @IBOutlet weak var expenseCurrencyTextField: UITextField!

  private var imagePickerController: UIImagePickerController? = UIImagePickerController()
  private var selectedExpenseTypePickerIndex: Int = 0

  var expenseViewModel: ExpenseViewModel?

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    guard let expenseService = ExpensesService() else { fatalError("Failed Expenses Service") }
    self.expenseViewModel = ExpenseViewModel(service: expenseService)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    imagePickerController?.delegate = self
  }

  private func setupUI(for expense: DBExpense) {
    // TODO
    expenseTitleTextField.text = expense.title
    expensePriceTextField.text = "\(expense.price)"
  }

  @IBAction private func takePhotoAction(
    _ sender: Any
  ) {
    imagePickerController?.sourceType = .camera
    guard let imagePickerController = imagePickerController else { return }
    present(imagePickerController, animated: true, completion: nil)
  }

  @IBAction private func selectImageAction(
    _ sender: Any
  ) {
    imagePickerController?.sourceType = .photoLibrary
    guard let imagePickerController = imagePickerController else { return }
    present(imagePickerController, animated: true, completion: nil)
  }

  @IBAction func saveExpenseAction(_ sender: Any) {
    guard let expenseTitle = expenseTitleTextField.text else { return }
    guard let expensePrice = expensePriceTextField.text else { return }
    guard let expenseCurrency = expenseCurrencyTextField.text else { return }
  
    expenseViewModel?.addExpense(
      title: expenseTitle,
      date: expenseDatePicker.date,
      price: Float(expensePrice) ?? 0.0,
      currency: expenseCurrency,
      type: ExpenseType.allCases[selectedExpenseTypePickerIndex]
    )
  }

  // MARK: UIImagePickerDelegate

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage  else { return }
    expenseImageView.image = image
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  // MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
  
  // MARK: UIPickerViewDelegate && UIPickerViewDataSource

  func pickerView(
    _ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int
  ) -> String? {
    return ExpenseType.allCases[row].stringValue
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return Constants.pickerViewComponentsNumber
  }
  
  func pickerView(
    _ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int
  ) -> Int {
    return ExpenseType.allCases.count
  }

  func pickerView(
    _ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int
  ) {
    selectedExpenseTypePickerIndex = row
  }
}

