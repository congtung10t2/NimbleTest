//
//  TokenManagerTests.swift
//  LoginAppTests
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
import XCTest
@testable import LoginApp

class TokenManagerTests: XCTestCase {
    var tokenManager: TokenManaging!
    var mockKeychain: MockKeychainSwift!

    override func setUp() {
        super.setUp()
        mockKeychain = MockKeychainSwift()
        tokenManager = TokenManager(keychain: mockKeychain)
    }

    override func tearDown() {
        mockKeychain = nil
        tokenManager = nil
        super.tearDown()
    }

    func testSaveTokens() {
        tokenManager.saveTokens(accessToken: "AccessToken", refreshToken: "RefreshToken", expiresIn: 3600, createdAt: Date().timeIntervalSince1970)
        XCTAssertEqual(mockKeychain.get("AccessToken"), "AccessToken")
        XCTAssertEqual(mockKeychain.get("RefreshToken"), "RefreshToken")
        XCTAssertNotNil(UserDefaults.standard.object(forKey: "AccessTokenExpirationKey"))
    }

    func testGetAccessToken() {
        mockKeychain.set("AccessToken", forKey: "AccessToken")
        let expirationDate = Date(timeIntervalSinceNow: 3600)
        UserDefaults.standard.set(expirationDate, forKey: "AccessTokenExpirationKey")
        
        let accessToken = tokenManager.getAccessToken()
        
        XCTAssertEqual(accessToken, "AccessToken")
    }

    func testGetRefreshToken() {
        mockKeychain.set("RefreshToken", forKey: "RefreshToken")
        
        let refreshToken = tokenManager.getRefreshToken()
        
        XCTAssertEqual(refreshToken, "RefreshToken")
    }

    func testGetAccessTokenExpiration() {
        let expirationDate = Date(timeIntervalSinceNow: 3600)
        UserDefaults.standard.set(expirationDate, forKey: "AccessTokenExpirationKey")
        
        let retrievedExpirationDate = tokenManager.getAccessTokenExpiration()
        
        XCTAssertEqual(retrievedExpirationDate, expirationDate)
    }

    func testClearTokens() {
        mockKeychain.set("AccessToken", forKey: "AccessToken")
        mockKeychain.set("RefreshToken", forKey: "RefreshToken")
        UserDefaults.standard.set(Date(), forKey: "AccessTokenExpirationKey")
        
        tokenManager.clearTokens()
        
        XCTAssertNil(mockKeychain.get("AccessToken"))
        XCTAssertNil(mockKeychain.get("RefreshToken"))
        XCTAssertNil(UserDefaults.standard.object(forKey: "AccessTokenExpirationKey"))
    }
    
    func testGetAccessTokenExpired() {
        // Set an expiration date in the past
        let expirationDate = Date(timeIntervalSinceNow: -1)
        UserDefaults.standard.set(expirationDate, forKey: "AccessTokenExpirationKey")
        
        // Attempt to retrieve the access token
        let accessToken = tokenManager.getAccessToken()
        
        // Verify that the access token is nil as it has expired
        XCTAssertNil(accessToken)
    }
}
