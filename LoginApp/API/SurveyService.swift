//
//  SurveyService.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import Moya

protocol SurveyService {
    func fetchSurvey(_ page: Int?,_ size: Int?, completion: @escaping (Result<SurveyResult, MoyaError>) -> Void)
}

class SurveyServiceImplement: SurveyService {
    var apiProvider: MoyaProvider<ApiRouter>
    var decoder: JSONDecoder
    
    init(provider: MoyaProvider<ApiRouter> = MoyaProvider<ApiRouter>(stubClosure: { target in
        return .immediate
    }),
         decoder: JSONDecoder = JSONDecoder()) {
        self.apiProvider = provider
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchSurvey(_ page: Int?,_ size: Int?, completion: @escaping (Result<SurveyResult, MoyaError>) -> Void) {
        apiProvider.request(.surveys(page: page, size: size)) { result in
            switch (result) {
            case .success(let response):
                do {
                    let surveyList = try self.decoder.decode(SurveyList.self, from: response.data)
                    completion(.success(SurveyResult.success(surveyList)))
                } catch {
                    do {
                        let errorResponse = try self.decoder.decode(ErrorResponse.self, from: response.data)
                        completion(.success(SurveyResult.errorResponse(errorResponse)))
                    } catch {
                        completion(.failure(MoyaError.objectMapping(error, response)))
                    }
                    completion(.failure(MoyaError.objectMapping(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
