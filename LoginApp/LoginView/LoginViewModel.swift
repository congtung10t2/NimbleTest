//
//  LoginViewModel.swift
//  LoginApp
//
//  Created by tungaptive on 30/11/2023.
//

import Foundation

protocol LoginUIComponentsProtocol {
    var components: [LoginType] { get }
    var forgetPassword: Bool { get }
}

struct LoginUIComponents: LoginUIComponentsProtocol {
    var components: [LoginType]
    var forgetPassword: Bool
}

class LoginViewModel {
    var configuration: LoginUIComponentsProtocol
    init(config: LoginUIComponentsProtocol) {
        self.configuration = config
    }
}
