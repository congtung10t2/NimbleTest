//
//  LoginViewController.swift
//  LoginApp
//
//  Created by tungaptive on 30/11/2023.
//

import Foundation
import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        contentStackView.distribution = .fillEqually
        contentStackView.alignment = .fill
        viewModel.configuration.components.forEach { component in
            let dynamicElement = component.created()
            switch component {
            case .button:
                break
            case .password:
                break
            default:
                break
            }
            contentStackView.addArrangedSubview(dynamicElement)
        }
    }
}

