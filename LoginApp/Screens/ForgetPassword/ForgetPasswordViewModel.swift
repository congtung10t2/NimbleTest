//
//  ForgetPasswordViewModel.swift
//  LoginApp
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
class ForgetPasswordViewModel {
    private(set) var configuration: LoginUIComponentsProtocol
    private var authenticationService: AuthenticationService
    init(configuration: LoginUIComponentsProtocol = LoginUIComponents(components: [.email, .button(label: "Reset")]), authenticationService: AuthenticationService = AuthenticationImplement()) {
        self.configuration = configuration
        self.authenticationService = authenticationService
    }
    
    func forgetPassword(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        self.authenticationService.forgetPassword(email: email) { result in
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                break
            }
        }
    }
}
