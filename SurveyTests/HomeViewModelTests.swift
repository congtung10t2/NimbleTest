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
        mockSurveyService = SurveyServiceImplement(provider: MoyaProvider<ApiRouter>(stubClosure: { _ in
            return .immediate
        }))
        mockTokenManager = MockTokenManager()
        mockAuthenticationService = AuthenticationImplement(provider: MoyaProvider<ApiRouter>(stubClosure: { _ in
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
    
    func testCacheDataWorking() {
        homeViewModel.saveDataToCache(pages: [OnboardingPage(coverUrl: "1", title: "2", description: "3")])
        
        let dataFromCache = homeViewModel.loadDataFromCache()
        XCTAssertEqual(dataFromCache?.count, 1)
        XCTAssertEqual(dataFromCache?.first?.coverUrl, "1")
        XCTAssertEqual(dataFromCache?.first?.title, "2")
        XCTAssertEqual(dataFromCache?.first?.description, "3")
    }
    
    func testLogOutReturnFalseWhenNoSession() {
        let homeViewModel = HomeViewModel(tokenManager: TokenManager(keychain: MockKeychainSwift()),
                                          surveyService: mockSurveyService,
                                          loginService: mockAuthenticationService)
        homeViewModel.clearOldTokenData()
        homeViewModel.logout() { result in
            switch result {
            case .success(let loggingOut):
                XCTAssertFalse(loggingOut)
            default:
                XCTFail("Test should failed when no token")
            }
        }
    }
}
