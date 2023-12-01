//
//  TokenManager.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import KeychainSwift

protocol TokenManaging {
    func saveTokens(accessToken: String, refreshToken: String, expiresIn: TimeInterval, createdAt: TimeInterval)
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func clearTokens()
}

class TokenManager: TokenManaging {
    
    static let shared = TokenManager()
    private let keychain = KeychainSwift()

    private let accessTokenKey = "AccessToken"
    private let refreshTokenKey = "RefreshToken"
    private var expirationDate: Date?

    func saveTokens(accessToken: String, refreshToken: String, expiresIn: TimeInterval, createdAt: TimeInterval) {
        keychain.set(accessToken, forKey: accessTokenKey)
        keychain.set(refreshToken, forKey: refreshTokenKey)
        self.expirationDate = Date(timeIntervalSince1970: createdAt + expiresIn)
    }
    
    func getAccessToken() -> String? {
        guard let expirationDate = expirationDate, expirationDate > Date() else {
            return nil
        }
        return keychain.get(accessTokenKey)
    }


    func getRefreshToken() -> String? {
        return keychain.get(refreshTokenKey)
    }

    func clearTokens() {
        keychain.delete(accessTokenKey)
        keychain.delete(refreshTokenKey)
    }
}
