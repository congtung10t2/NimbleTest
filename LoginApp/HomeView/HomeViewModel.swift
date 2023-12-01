//
//  HomeViewModel.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation

class HomeViewModel {
    private var loginService: LoginService
    private var tokenManager: TokenManaging
    
    init(tokenManager: TokenManaging = TokenManager.shared,
         loginService: LoginService = LoginServiceImplement()) {
        self.loginService = loginService
        self.tokenManager = tokenManager
    }
    
    func fetchSurveyList() {
        
    }
}
