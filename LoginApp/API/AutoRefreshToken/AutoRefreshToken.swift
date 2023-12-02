//
//  AutoRefreshToken.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import Moya

class AutoRefreshToken {
    static let shared = AutoRefreshToken()
    private var tokenManager: TokenManaging
    private var loginService: AuthenticationService
    private var timer: Timer?
    private var retryCount = 0

    private init(tokenManager: TokenManaging = TokenManager.shared, loginService: AuthenticationService = AuthenticationImplement()) {
        self.tokenManager = tokenManager
        self.loginService = loginService
    }

    deinit {
        stopTimer()
    }

    func startTokenRefresh() {
        guard let refreshToken = tokenManager.getRefreshToken(),
              let expiration = tokenManager.getAccessTokenExpiration() else {
            return
        }
        stopTimer()
        let remainingValidity = expiration.timeIntervalSinceNow
        timer = Timer.scheduledTimer(withTimeInterval: remainingValidity, repeats: false) { [weak self] _ in
            self?.checkTokenExpiration(refreshToken: refreshToken)
        }
        checkTokenExpiration(refreshToken: refreshToken)
    }

    private func checkTokenExpiration(refreshToken: String) {
        guard let expiration = tokenManager.getAccessTokenExpiration() else {
            return
        }
        let remainingValidity = expiration.timeIntervalSinceNow

        if remainingValidity < 0 {
            retryCount = retryCount + 1
            loginService.login(refreshToken: refreshToken) { result in
                self.handleLoginResult(result)
            }
        }
    }
    
    private func handleLoginResult(_ result: Result<LoginResult, MoyaError>) {
        switch result {
        case .success(let response):
            switch response {
            case .success(let response):
                let accessToken = response.data.attributes.accessToken
                let refreshToken = response.data.attributes.refreshToken
                let expiresIn = TimeInterval(response.data.attributes.expiresIn)
                let createdAt = TimeInterval(response.data.attributes.createdAt)
                tokenManager.saveTokens(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn, createdAt: createdAt)
                startTokenRefresh()
                retryCount = 0
            case .failure(let error):
                retryCount = retryCount + 1
                debugPrint(error)
            case .errorResponse(let error):
                retryCount = retryCount + 1
                let message = error.errors.first?.detail ?? ""
                let error = NSError(domain: "", code: 0, userInfo: ["message": message])
                debugPrint(error)
            }
        case .failure(let error):
            retryCount = retryCount + 1
            debugPrint(error)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
