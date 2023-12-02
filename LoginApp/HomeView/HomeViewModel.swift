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
    private var loginService: LoginService
    
    init(tokenManager: TokenManaging = TokenManager.shared,
         surveyService: SurveyService = SurveyServiceImplement(),
         loginService: LoginService = LoginServiceImplement()) {
        self.surveyService = surveyService
        self.tokenManager = tokenManager
        self.loginService = loginService
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
                    let message = response.errors.first?.detail ?? ""
                    let error = NSError(domain: "", code: 0, userInfo: ["message": message])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout() {
        //TODO: to implement logout service
    }
}
