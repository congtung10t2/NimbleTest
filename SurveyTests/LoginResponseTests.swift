//
//  LoginResponseTests.swift
//  SurveyAppTests
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
import XCTest
@testable import SurveyApp

class LoginResponseTests: XCTestCase {
    
    func testLoginResponseDecoding() throws {
        guard let url = Bundle.main.url(forResource: "LoginResponse", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let loginResponse = try decoder.decode(LoginResponse.self, from: jsonData)
        
        XCTAssertEqual(loginResponse.data.id, "30191")
        XCTAssertEqual(loginResponse.data.type, "token")
        XCTAssertEqual(loginResponse.data.attributes.accessToken, "dVje4RkXGuuuIULsjscQ-L9Pxc0ZJjS57jqwZsBJtWM")
        XCTAssertEqual(loginResponse.data.attributes.tokenType, "Bearer")
        XCTAssertEqual(loginResponse.data.attributes.expiresIn, 7200)
        XCTAssertEqual(loginResponse.data.attributes.refreshToken, "s1rvoePrIvlX9FuxlGjnEFuj0_Qlmm_y8ZrYa3Xjp0I")
        XCTAssertEqual(loginResponse.data.attributes.createdAt, 1701316225)
    }
    
    func testLogoutResponseDecoding() throws {
        let json = "{}"
        let jsonData = Data(json.utf8)
        let logoutResponse = try JSONDecoder().decode(LogoutResponse.self, from: jsonData)
        // Since LogoutResponse is an empty struct, we don't need to check any properties
        XCTAssertTrue(logoutResponse is LogoutResponse)
    }
    
    func testGetError() {
        let errorResponse = ErrorResponse(errors: [ErrorDetail(detail: "Error message", code: "123")])
        let error = errorResponse.getError()
        XCTAssertEqual(error.domain, "")
        XCTAssertEqual(error.code, 0)
        XCTAssertEqual(error.userInfo["message"] as? String, "Error message")
    }
    
    func testLoginResultEnum() {
        let successResult = LoginResult.success(LoginResponse(data: TokenData(id: "1", type: "login", attributes: TokenAttributes(accessToken: "abc", tokenType: "Bearer", expiresIn: 3600, refreshToken: "xyz", createdAt: 1638578000))))
        let failureResult = LoginResult.failure(NSError(domain: "Test", code: 1, userInfo: nil))
        let errorResponseResult = LoginResult.errorResponse(ErrorResponse(errors: [ErrorDetail(detail: "Error", code: "123")]))
        
        switch successResult {
        case .success(let loginResponse):
            XCTAssertEqual(loginResponse.data.id, "1")
            XCTAssertEqual(loginResponse.data.type, "login")
        case .failure:
            XCTFail("Expected success, got failure")
        case .errorResponse:
            XCTFail("Expected success, got error response")
        }
    }
}
