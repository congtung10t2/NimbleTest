//
//  LoginResponse.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation

struct LoginResponse: Codable {
    let data: TokenData
}

struct LogoutResponse: Codable {}

struct TokenData: Codable {
    let id: String
    let type: String
    let attributes: TokenAttributes
}

struct TokenAttributes: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let createdAt: Int
}

struct ErrorResponse: Codable {
    let errors: [ErrorDetail]
}

struct ErrorDetail: Codable {
    let detail: String
    let code: String
}

enum LoginResult {
    case success(LoginResponse)
    case failure(Error)
    case errorResponse(ErrorResponse)
}


enum LogoutResult {
    case success
    case failure(Error)
    case errorResponse(ErrorResponse)
}
