//
//  Endpoint.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import Moya

enum Endpoint {
    //TODO: - baseUrl, clientId and secret can put in xcconfig when we have more envs
    static let clientId = "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE"
    static let clientSecret = "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"
    
    case login(email: String, password: String)
    case loginWithToken(token: String)
    case logout(token: String)
    case surveys(page: Int?, size: Int?)
    case forgetPassword(email: String)
}

extension Endpoint: TargetType {
    public var baseURL: URL {
        URL(string: "https://survey-api.nimblehq.co/api/v1")!
    }
    
    public var path: String {
        switch self {
        case .login, .loginWithToken:
            return "/oauth/token"
        case .logout:
            return "/oauth/revoke"
        case .surveys:
            return "/surveys"
            
        case .forgetPassword:
            return "/passwords"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .surveys:
            return .get
        default:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters:
                                        ["grant_type": "password",
                                         "email": email,
                                         "password": password,
                                         "client_id": Self.clientId,
                                         "client_secret": Self.clientSecret],
                                      encoding: JSONEncoding.default)
        case .logout(let token):
            return .requestParameters(parameters: ["token": token,
                                                   "client_id": Self.clientId,
                                                   "client_secret": Self.clientSecret],
                                      encoding: JSONEncoding.default)
        case .loginWithToken(let token):
            return .requestParameters(parameters: ["token": token,
                                                   "client_id": Self.clientId,
                                                   "client_secret": Self.clientSecret],
                                      encoding: JSONEncoding.default)
        case .surveys(let page, let size):
            var params: [String: Any] = [:]
            if let page {
                params["page[number]"] = page
            }
            
            if let size {
                params["page[size]"] = size
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .forgetPassword(let email):
            let body: [String: Any] = [
                "user": [
                    "email": "\(email)"
                ],
                "client_id": Self.clientId,
                "client_secret": Self.clientSecret
            ]
            return .requestParameters(parameters: body,
                                      encoding: JSONEncoding.default)
        }
        
    }
    
    public var headers: [String : String]? {
        if let accessToken = TokenManager.shared.getAccessToken() {
            return ["Content-type": "application/json",
                    "Authorization": "Bearer \(accessToken)"]
        }
        return nil
    }
    
    public var sampleData: Data {
        var fileName: String?
        switch self {
        case .logout:
            fileName = "LogoutResponse"
        case .login, .loginWithToken:
            fileName = "LoginResponse"
        case .surveys:
            fileName = "SurveyResponse"
        case .forgetPassword:
            fileName = "ForgetPassword"
        }
        guard let fileName else {
            return Data()
        }
        return Self.getSampleData(fileName: fileName)
    }
    
    
}

private extension Endpoint {
    static func getSampleData(fileName: String) -> Data {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Data()
        }
        return data
    }
}
