//
//  SurveyService.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import Moya

protocol SurveyService {
    
}

class SurveyServiceImplement: SurveyService {
    var apiProvider: MoyaProvider<Endpoint>
    var decoder: JSONDecoder
    
    init(provider: MoyaProvider<Endpoint> = MoyaProvider<Endpoint>(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.apiProvider = provider
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}
