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

protocol KeychainProtocol {
    @discardableResult
    func set(_ value: String, forKey key: String,
             withAccess access: KeychainSwiftAccessOptions?) -> Bool
    func get(_ key: String) -> String?
    func delete(_ key: String) -> Bool
}

extension KeychainSwift: KeychainProtocol {}

class TokenManager: TokenManaging {
    
    static let shared = TokenManager(keychain: KeychainSwift())
    public init(keychain: KeychainProtocol) {
        self.keychain = keychain
    }
    
    private let keychain: KeychainProtocol
    
    private let accessTokenKey = "AccessToken"
    private let refreshTokenKey = "RefreshToken"
    private let accessTokenExpirationKey = "AccessTokenExpirationKey"

    func saveTokens(accessToken: String, refreshToken: String, expiresIn: TimeInterval, createdAt: TimeInterval) {
        keychain.set(accessToken, forKey: accessTokenKey, withAccess: nil)
        keychain.set(refreshToken, forKey: refreshTokenKey, withAccess: nil)
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
