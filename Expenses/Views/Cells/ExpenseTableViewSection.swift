//
//  ExpenseTableViewSection.swift
//  Expenses
//
//  Created by Valentina Vențel on 16.08.2024.
//

import UIKit

final class ExpenseTableViewSection: UITableViewHeaderFooterView {
  @IBOutlet private weak var sectionTitleLabl: UILabel!
  
  func custom(sectionTitle: String) {
    sectionTitleLabl.text = sectionTitle
  }
}
