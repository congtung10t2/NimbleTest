//
//  LoginViewModel.swift
//  LoginApp
//
//  Created by tungaptive on 30/11/2023.
//
import Foundation
import Moya

protocol LoginUIComponentsProtocol {
    var components: [LoginType] { get }
    var forgetPassword: Bool { get }
}

struct LoginUIComponents: LoginUIComponentsProtocol {
    var components: [LoginType]
    var forgetPassword: Bool
}

class LoginViewModel {
    private(set) var configuration: LoginUIComponentsProtocol
    private var loginService: LoginService
    private var tokenManager: TokenManaging
    
    init(config: LoginUIComponentsProtocol = LoginUIComponents(components: [.email, .password, .button(label: "Log in")], forgetPassword: true),
         tokenManager: TokenManaging = TokenManager(),
         loginService: LoginService = LoginServiceImplement()) {
        self.configuration = config
        self.loginService = loginService
        self.tokenManager = tokenManager
    }
    
    private func handleLoginResult(_ result: Result<LoginResult, MoyaError>, completion: @escaping (Result<Bool, Error>) -> Void) {
        switch result {
        case .success(let response):
            switch response {
            case .success(let response):
                let accessToken = response.data.attributes.accessToken
                let refreshToken = response.data.attributes.refreshToken
                let expiresIn = TimeInterval(response.data.attributes.expiresIn)
                let createdAt = TimeInterval(response.data.attributes.createdAt)
                tokenManager.saveTokens(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn, createdAt: createdAt)
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            case .loginError(let error):
                let message = error.errors.first?.detail ?? ""
                let error = NSError(domain: "", code: 0, userInfo: ["message": message])
                completion(.failure(error))
            }
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        loginService.login(email: email, password: password) { result in
            self.handleLoginResult(result, completion: completion)
        }
    }
    
    func login(token: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        loginService.login(refreshToken: token) { result in
            self.handleLoginResult(result, completion: completion)
        }
    }
}
