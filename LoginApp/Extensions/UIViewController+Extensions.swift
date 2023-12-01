//
//  UIViewController+Extensions.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Handle the OK button action if needed
            completion?()
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
