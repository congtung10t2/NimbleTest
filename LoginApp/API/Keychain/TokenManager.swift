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
    func getAccessTokenExpiration() -> Date?
    func clearTokens()
}

class TokenManager: TokenManaging {
    
    static let shared = TokenManager()
    private init() {}
    
    private let keychain = KeychainSwift()
    
    private let accessTokenKey = "AccessToken"
    private let refreshTokenKey = "RefreshToken"
    private let accessTokenExpirationKey = "AccessTokenExpirationKey"

    func saveTokens(accessToken: String, refreshToken: String, expiresIn: TimeInterval, createdAt: TimeInterval) {
        keychain.set(accessToken, forKey: accessTokenKey)
        keychain.set(refreshToken, forKey: refreshTokenKey)
        let expirationDate = Date(timeIntervalSince1970: createdAt + expiresIn)
        UserDefaults.standard.set(expirationDate, forKey: accessTokenExpirationKey)
    }
    
    func getAccessToken() -> String? {
        guard let expirationDate = UserDefaults.standard.object(forKey: accessTokenExpirationKey) as? Date, expirationDate > Date() else {
            return nil
        }
        return keychain.get(accessTokenKey)
    }

    func getRefreshToken() -> String? {
        return keychain.get(refreshTokenKey)
    }
    
    func getAccessTokenExpiration() -> Date? {
        return UserDefaults.standard.object(forKey: accessTokenExpirationKey) as? Date
    }

    func clearTokens() {
        keychain.delete(accessTokenKey)
        keychain.delete(refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: accessTokenExpirationKey)
    }
}
