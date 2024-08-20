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

func saveImageToDisk(
  image: UIImage,
  with name: String,
  completionHandler: @escaping(URL?) -> ()
) {
  guard let documentsDirectory = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  ).first else {
    fatalError("Failed to find documents directory.")
  }

  let imageURL = documentsDirectory.appendingPathComponent("\(name).jpg")

  guard let data = image.jpegData(compressionQuality: 0) else {
    fatalError("Failed to convert image to JPG data.")
  }

  DispatchQueue.global(qos: .background).async {
    do {
      try data.write(to: imageURL)

      DispatchQueue.main.async {
        completionHandler(imageURL)
      }
    } catch {
      completionHandler(nil)
    }
  }
}
