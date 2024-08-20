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
    static let alertErrorTitle: String = "Error"
    static let alertErrorMessage: String = "The expense infos are required"
    static let buttonTitle: String = "Ok"
    static let cameraString: String = "camera"
    static let alertSuccessTitle: String = "Congratulation"
    static let alertSuccessMessage: String = "A new expense was added successfully!"
    static let fatalErrorMessage: String = "Failed Expenses Service"
  }

  @IBOutlet private weak var expenseImageView: UIImageView!
  @IBOutlet private weak var expenseTitleTextField: UITextField!
  @IBOutlet private weak var expensePriceTextField: UITextField!
  @IBOutlet private weak var expenseTypePicker: UIPickerView!
  @IBOutlet private weak var expenseDatePicker: UIDatePicker!
  @IBOutlet weak var expenseCurrencyTextField: UITextField!
  @IBOutlet weak var activityIndicatorView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  private var imagePickerController: UIImagePickerController? = UIImagePickerController()
  private var selectedExpenseTypePickerIndex: Int = 0
  private var expenseImage: UIImage?

  var expenseViewModel: ExpenseViewModel?

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    guard let expenseService = appDelegate.expensesService else { fatalError(Constants.fatalErrorMessage) }
    self.expenseViewModel = ExpenseViewModelImpl(service: expenseService)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    imagePickerController?.delegate = self
    setupActivityIndicatorState(true)
    setupBindings()
  }
  
  private func setupUI(
    for expense: Bool = true,
    image: UIImage = UIImage(systemName: Constants.cameraString) ?? UIImage(),
    title: String = "",
    date: Date = Date.now,
    price: Float = .zero,
    currency: String = "",
    type: ExpenseType = ExpenseType.receipt
  ) {
    if !expense {
      showAlertPopup(
        title: Constants.alertSuccessTitle,
        message: Constants.alertSuccessMessage
      )
    }

    expenseImageView.image = image
    expenseTitleTextField.text = title
    expensePriceTextField.text = (price == .zero)
      ? ""
      : String(describing: price)
    expenseCurrencyTextField.text = currency
    expenseDatePicker.date = date
    expenseTypePicker.selectRow(
      type.rawValue,
      inComponent: 0,
      animated: false
    )
    
  }
  
  private func setupBindings() {
    expenseViewModel?.isLoading.bind() { [weak self] isLoading in
      self?.setupActivityIndicatorState(isLoading)
    }
    expenseViewModel?.errorObservable.bind() { [weak self] errorMessage in
      if !errorMessage.isEmpty {
        self?.showAlertPopup(
          title: Constants.alertErrorTitle,
          message: errorMessage
        )
      }
    }
    expenseViewModel?.expenseWasAddedSuccessfully.bind() { [weak self] wasSuccessfully in
      if wasSuccessfully {
        self?.setupUI(for: false)
      }
    }
  }
  
  private func setupActivityIndicatorState(_ isLoading: Bool) {
    activityIndicatorView.isHidden = !isLoading
    isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
  }
  
  private func showAlertPopup(
    title: String,
    message: String
  ) {
    let alertController = customAlertController(
      title: title,
      message: message,
      buttonTitle: Constants.buttonTitle
    )
    present(
      alertController,
      animated: true
    )
  }

  @IBAction func goBackAction(_ sender: Any) {
    self.dismiss(animated: true)
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
    guard let expenseTitle = expenseTitleTextField.text,
          let expensePrice = expensePriceTextField.text,
          let expenseCurrency = expenseCurrencyTextField.text,
          !expenseTitle.isEmpty,
          !expensePrice.isEmpty,
          !expenseCurrency.isEmpty
    else {
      showAlertPopup(
        title: Constants.alertErrorTitle,
        message: Constants.alertErrorMessage
      )
      return
    }
    
    guard let expenseImage = expenseImage else { return }
    expenseViewModel?.addExpense(
      expenseImage: expenseImage,
      title: expenseTitle,
      date: expenseDatePicker.date,
      price: Float(expensePrice) ?? .zero,
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
    expenseImage = image
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

