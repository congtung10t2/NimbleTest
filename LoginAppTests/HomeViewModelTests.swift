//
//  HomeViewModelTests.swift
//  SurveyAppTests
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
import XCTest
import Moya
@testable import SurveyApp

class HomeViewModelTests: XCTestCase {
    
    var homeViewModel: HomeViewModel!
    var mockSurveyService: SurveyService!
    var mockTokenManager: MockTokenManager!
    var mockAuthenticationService: AuthenticationService!
    
    override func setUp() {
        super.setUp()
        mockSurveyService = SurveyServiceImplement(provider: MoyaProvider<ApiRouter>(stubClosure: { target in
            return .immediate
        }))
        mockTokenManager = MockTokenManager()
        mockAuthenticationService = AuthenticationImplement(provider: MoyaProvider<ApiRouter>(stubClosure: { target in
            return .immediate
        }))
        homeViewModel = HomeViewModel(
            tokenManager: mockTokenManager,
            surveyService: mockSurveyService,
            loginService: mockAuthenticationService
        )
    }
    
    override func tearDown() {
        mockSurveyService = nil
        mockTokenManager = nil
        mockAuthenticationService = nil
        homeViewModel = nil
        super.tearDown()
    }
    
    func testFetchSurveyListSuccess() throws {
        guard let url = Bundle.main.url(forResource: "SurveyResponse", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return
        }
        let expectation = self.expectation(description: "Fetch survey list successful")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let surveyList = try decoder.decode(SurveyList.self, from: jsonData)
        homeViewModel.fetchSurveyList { result in
            switch result {
            case .success(let onboardingPages):
                XCTAssertEqual(onboardingPages.count, surveyList.data.count)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
