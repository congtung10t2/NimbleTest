//
//  ForgetPasswordViewController.swift
//  LoginApp
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
import UIKit
class ForgetPasswordViewController: BaseViewController {
    let viewModel: ForgetPasswordViewModel
    var emailTextField: UITextField!
    init(viewModel: ForgetPasswordViewModel) {
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
                guard let loginButton = dynamicElement as? UIButton else {
                    return
                }
                loginButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
                break
            case .email:
                guard let emailTextField = dynamicElement as? UITextField else {
                    return
                }
                self.emailTextField = emailTextField
                
            default:
                break
            }
            contentStackView.addArrangedSubview(dynamicElement)
        }
        addBlurView()
        hideLoading()
    }
    
    @objc func resetTapped() {
        guard let email = emailTextField.text else {
            showAlert(title: "Nimble", message: "Please fill in a valid email!")
            return
        }
        showLoading()
        viewModel.forgetPassword(email: email) {[weak self] result in
            guard let self else {
                return
            }
            self.hideLoading()
            switch result {
            case .success(let message):
                self.showAlert(title: "Nimble", message: message)
            case .failure(let error):
                guard let message = (error as? NSError)?.userInfo["message"] else {
                    return
                }
                self.showAlert(title: "Error", message: "\(message)")
            }
        }
    }
}
