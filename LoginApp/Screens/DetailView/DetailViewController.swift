//
//  DetailViewController.swift
//  LoginApp
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail Survey"
        
        // Create a custom back button with the title "Back"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
       // backButton.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .white
    }
}
