//
//  LoginViewModel.swift
//  SurveyApp
//
//  Created by tungaptive on 30/11/2023.
//
import Foundation
import Moya

protocol LoginUIComponentsProtocol {
    var components: [LoginType] { get }
}

struct LoginUIComponents: LoginUIComponentsProtocol {
    var components: [LoginType]
}

class LoginViewModel {
    private(set) var configuration: LoginUIComponentsProtocol
    private var loginService: AuthenticationService
    private var tokenManager: TokenManaging
    
    init(config: LoginUIComponentsProtocol = LoginUIComponents(components: [.email, .password, .button(label: "Log in")]),
         tokenManager: TokenManaging = TokenManager.shared,
         loginService: AuthenticationService = AuthenticationImplement()) {
        self.configuration = config
        self.loginService = loginService
        self.tokenManager = tokenManager
    }
    
    private func handleLoginResult(_ result: Result<LoginResult, MoyaError>, completion: @escaping (Result<Bool, Error>) -> Void) {
        switch result {
        case .success(let response):
            switch response {
            case .success(let response):
                response.save()
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            case .errorResponse(let error):
                completion(.failure(error.getError()))
            }
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard !email.isEmpty && !password.isEmpty else {
            let nsError = NSError(domain: "login", code: 0, userInfo: ["message": "Email or password is empty"])
            completion(.failure(nsError))
            return
        }
        loginService.login(email: email, password: password) { result in
            self.handleLoginResult(result, completion: completion)
        }
    }
}
