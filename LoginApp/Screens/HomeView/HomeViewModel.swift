//
//  HomeViewModel.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import Moya

class HomeViewModel {
    private var surveyService: SurveyService
    private var tokenManager: TokenManaging
    private var authenticationService: AuthenticationService
    
    init(tokenManager: TokenManaging = TokenManager.shared,
         surveyService: SurveyService = SurveyServiceImplement(),
         loginService: AuthenticationService = AuthenticationImplement()) {
        self.surveyService = surveyService
        self.tokenManager = tokenManager
        self.authenticationService = loginService
    }
    
    func fetchSurveyList(completion: @escaping (Result<[OnboardingPage], Error>) -> Void) {
        surveyService.fetchSurvey(nil, nil) { result in
            switch result {
            case .success(let response):
                switch response {
                case .success(let surveyList):
                    completion(.success(surveyList.data.map { OnboardingPage(survey: $0) }))
                case .failure(let error):
                    completion(.failure(error))
                case .errorResponse(let response):
                    completion(.failure(response.getError()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func clearOldTokenData() {
        tokenManager.clearTokens()
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
