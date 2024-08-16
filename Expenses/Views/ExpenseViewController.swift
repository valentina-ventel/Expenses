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
  UINavigationControllerDelegate
{
  @IBOutlet private weak var expenseImageView: UIImageView!
  private var imagePickerController: UIImagePickerController? = UIImagePickerController()

  override func viewDidLoad() {
    super.viewDidLoad()
    imagePickerController?.delegate = self
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
}

