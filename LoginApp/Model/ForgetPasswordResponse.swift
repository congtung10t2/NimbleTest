//
//  ForgetPasswordResponse.swift
//  LoginApp
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
struct ForgetPasswordResponse: Codable {
    let meta: ForgetPasswordMeta
}

struct ForgetPasswordMeta: Codable {
    let message: String
}

enum ForgetPasswordResult {
    case success(message: String)
    case failure(Error)
    case errorResponse(ErrorResponse)
}
