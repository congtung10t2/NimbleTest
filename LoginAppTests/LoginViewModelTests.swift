//
//  LoginViewModelTests.swift
//  LoginAppTests
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
import XCTest
import Moya
@testable import LoginApp

final class LoginViewModelTests: XCTestCase {
    var loginViewModel: LoginViewModel!
    var mockTokenManager: MockTokenManager!
    var mockAuthenticationService: AuthenticationService!
    
    override func setUp() {
        super.setUp()
        mockTokenManager = MockTokenManager()
        mockAuthenticationService = AuthenticationImplement(provider: MoyaProvider<ApiRouter>(stubClosure: { target in
            return .immediate
        }))
        loginViewModel = LoginViewModel(tokenManager: mockTokenManager, loginService: mockAuthenticationService)
    }
    
    override func tearDown() {
        mockTokenManager = nil
        mockAuthenticationService = nil
        loginViewModel = nil
        super.tearDown()
    }
    
    func testLoginSuccess() {
        let expectation = self.expectation(description: "Test login successful")
        let email = "test@example.com"
        let password = "password"
        loginViewModel.login(email: email, password: password) { result in
            XCTAssertEqual(self.mockTokenManager.getAccessToken(), "dVje4RkXGuuuIULsjscQ-L9Pxc0ZJjS57jqwZsBJtWM")
            XCTAssertEqual(self.mockTokenManager.getRefreshToken(), "s1rvoePrIvlX9FuxlGjnEFuj0_Qlmm_y8ZrYa3Xjp0I")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
