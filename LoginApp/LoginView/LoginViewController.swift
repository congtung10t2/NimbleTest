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
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
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
        clearUserData()
    }
    
    func clearUserData() {
        viewModel.clearOldTokenData()
    }
    
    func setupUI() {
        contentStackView.distribution = .fillEqually
        contentStackView.alignment = .fill
        viewModel.configuration.components.forEach { component in
            let dynamicElement = component.created()
            switch component {
            case .button:
                guard let loginButton = dynamicElement as? UIButton else {
                    return
                }
                loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
                break
            case .email:
                guard let emailTextField = dynamicElement as? UITextField else {
                    return
                }
                self.emailTextField = emailTextField
                
            case .password:
                guard let passwordTextField = dynamicElement as? UITextField else {
                    return
                }
                self.passwordTextField = passwordTextField
            }
            contentStackView.addArrangedSubview(dynamicElement)
        }
    }
    
    @objc func loginTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        viewModel.login(email: email, password: password) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success:
                let homeViewController = HomeViewController()
                homeViewController.modalPresentationStyle = .fullScreen
                self.present(homeViewController, animated: true)
            case .failure(let error):
                guard let message = (error as? NSError)?.userInfo["message"] else {
                    return
                }
                self.showAlert(title: "Login failed", message: "\(message)")
            }
        }
    }
}

