//
//  MockTokenManager.swift
//  SurveyAppTests
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
@testable import SurveyApp

class MockTokenManager: TokenManaging {

    var savedTokens: (accessToken: String, refreshToken: String, expiresIn: TimeInterval, createdAt: TimeInterval)?

    func saveTokens(accessToken: String, refreshToken: String, expiresIn: TimeInterval, createdAt: TimeInterval) {
        savedTokens = (accessToken, refreshToken, expiresIn, createdAt)
    }

    func getAccessToken() -> String? {
        return savedTokens?.accessToken
    }

    func getRefreshToken() -> String? {
        return savedTokens?.refreshToken
    }

    func getAccessTokenExpiration() -> Date? {
        return savedTokens != nil ? Date(timeIntervalSince1970: savedTokens!.createdAt + savedTokens!.expiresIn) : nil
    }

    func clearTokens() {
        savedTokens = nil
    }
}
