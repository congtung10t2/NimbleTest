//
//  HomeViewModel.swift
//  SurveyApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import Moya

class HomeViewModel {
    private var surveyService: SurveyService
    private var tokenManager: TokenManaging
    private var authenticationService: AuthenticationService
    private let cacheFile = "surveyList"
    private let invalidTokenCode = "invalid_token"
    
    init(tokenManager: TokenManaging = TokenManager.shared,
         surveyService: SurveyService = SurveyServiceImplement(),
         loginService: AuthenticationService = AuthenticationImplement()) {
        self.surveyService = surveyService
        self.tokenManager = tokenManager
        self.authenticationService = loginService
    }
    
    func fetchSurveyList(completion: @escaping (Result<[OnboardingPage], Error>) -> Void) {
        surveyService.fetchSurvey(nil, nil) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let response):
                switch response {
                case .success(let surveyList):
                    
                    completion(.success(surveyList.data.map { OnboardingPage(survey: $0) }))
                case .failure(let error):
                    completion(.failure(error))
                case .errorResponse(let response):
                    if response.errors.contains(where: { $0.code == self.invalidTokenCode }) {
                        self.loginThenFetch(completion: completion)
                    }
                    completion(.failure(response.getError()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func loginThenFetch(completion: @escaping (Result<[OnboardingPage], Error>) -> Void) {
        guard let refreshToken = tokenManager.getRefreshToken() else {
            let nsError = NSError(domain: "login", code: 0, userInfo: ["message": "No refresh token, please logout and login again"])
            completion(.failure(nsError))
            return
        }
        authenticationService.login(refreshToken: refreshToken) {[weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let validResponse):
                switch validResponse {
                case .success(let loginResponse):
                    loginResponse.save()
                    fetchSurveyList(completion: completion)
                case .errorResponse(let errorResponse):
                    completion(.failure(errorResponse.getError()))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func clearOldTokenData() {
        tokenManager.clearTokens()
        clearCacheFile()
    }
    
    func clearCacheFile() {
        CacheManager.clearCache()
    }
    
    func saveDataToCache(pages: [OnboardingPage]) {
        CacheManager.removeCacheFile(fileName: cacheFile)
        CacheManager.saveDataToCache(pages, fileName: cacheFile)
    }
    
    func loadDataFromCache() -> [OnboardingPage]? {
        return CacheManager.loadDataFromCache([OnboardingPage].self, fileName: cacheFile)
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let accessToken = tokenManager.getAccessToken() else {
            completion(.success(false))
            return
        }
        authenticationService.logout(token: accessToken) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
