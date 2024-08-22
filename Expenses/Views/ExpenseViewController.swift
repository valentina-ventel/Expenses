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
  UITextFieldDelegate
{
  private enum Constants {
    static let pickerViewComponentsNumber: Int = 1
    static let alertErrorTitle: String = "Error"
    static let alertErrorMessage: String = "The expense info are required"
    static let buttonTitle: String = "Ok"
    static let cameraString: String = "camera"
    static let alertSuccessTitle: String = "Congratulation"
    static let alertSuccessMessage: String = "A new expense was added successfully!"
    static let fatalErrorMessage: String = "Failed Expenses Service"
  }

  @IBOutlet private weak var expenseImageView: UIImageView!
  @IBOutlet private weak var expenseTitleTextField: UITextField!
  @IBOutlet private weak var expensePriceTextField: UITextField!
  @IBOutlet private weak var expenseTypeSegmentedControl: UISegmentedControl!
  @IBOutlet private weak var expenseDatePicker: UIDatePicker!
  @IBOutlet weak var expenseCurrencyTextField: UITextField!
  @IBOutlet weak var activityIndicatorView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var textFieldsStackView: UIStackView!
  
  private var imagePickerController: UIImagePickerController? = UIImagePickerController()
  private var selectedExpenseTypePickerIndex: Int = 0
  private var isKeyboardVisible: Bool = false
  private var expenseImage: UIImage?

  var expenseViewModel: ExpenseViewModel?

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    guard let expenseService = appDelegate.expensesService else { fatalError(Constants.fatalErrorMessage) }
    self.expenseViewModel = ExpenseViewModelImpl(service: expenseService)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    imagePickerController?.delegate = self
    setupActivityIndicatorState(true)
    setupBindings()
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateScrollContentSize),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateScrollContentSize),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
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
    expenseTypeSegmentedControl.selectedSegmentIndex = type.rawValue
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

  @objc func updateScrollContentSize(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }
    if isKeyboardVisible == !(notification.name == UIResponder.keyboardWillShowNotification) {
      isKeyboardVisible = (notification.name == UIResponder.keyboardWillShowNotification)
      let scrollViewContentHeight = isKeyboardVisible
        ? scrollView.contentSize.height + keyboardFrame.cgRectValue.height
        : scrollView.contentSize.height - keyboardFrame.cgRectValue.height
      scrollView.contentSize = CGSize(
        width: scrollView.frame.width,
        height:scrollViewContentHeight
      )
      scrollView.contentOffset.y = isKeyboardVisible ? textFieldsStackView.frame.origin.y : 0
    }
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
      type: ExpenseType.allCases[expenseTypeSegmentedControl.selectedSegmentIndex]
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

}

