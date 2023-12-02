//
//  LoginService.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import Moya

protocol AuthenticationService {
    func login(email: String, password: String, completion: @escaping (Result<LoginResult, MoyaError>) -> Void)
    func login(refreshToken: String, completion: @escaping (Result<LoginResult, MoyaError>) -> Void)
    func logout(token: String, completion: @escaping (Result<LogoutResult, MoyaError>) -> Void)
}

class AuthenticationImplement: AuthenticationService {
    var apiProvider: MoyaProvider<Endpoint>
    var decoder: JSONDecoder
    
    init(provider: MoyaProvider<Endpoint> = MoyaProvider<Endpoint>(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.apiProvider = provider
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func handleLoginResult(result: Result<Response, MoyaError>, completion: @escaping (Result<LoginResult, MoyaError>) -> Void) {
        switch result {
        case .success(let response):
            do {
                let loginResponse = try self.decoder.decode(LoginResponse.self, from: response.data)
                completion(.success(LoginResult.success(loginResponse)))
            } catch {
                do {
                    let errorResponse = try self.decoder.decode(ErrorResponse.self, from: response.data)
                    completion(.success(LoginResult.errorResponse(errorResponse)))
                } catch {
                    completion(.failure(MoyaError.objectMapping(error, response)))
                }
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResult, MoyaError>) -> Void) {
        apiProvider.request(.login(email: email, password: password)) { result in
            self.handleLoginResult(result: result, completion: completion)
        }
    }
    
    func login(refreshToken: String, completion: @escaping (Result<LoginResult, MoyaError>) -> Void) {
        apiProvider.request(.loginWithToken(token: refreshToken)) { result in
            self.handleLoginResult(result: result, completion: completion)
        }
    }
    
    func logout(token: String, completion: @escaping (Result<LogoutResult, MoyaError>) -> Void) {
        apiProvider.request(.logout(token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let errorResponse = try self.decoder.decode(LogoutResponse.self, from: response.data)
                    completion(.success(LogoutResult.success))
                } catch {
                    do {
                        let errorResponse = try self.decoder.decode(ErrorResponse.self, from: response.data)
                        completion(.success(LogoutResult.errorResponse(errorResponse)))
                    } catch {
                        completion(.failure(MoyaError.objectMapping(error, response)))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

