//
//  Endpoint.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation
import Moya

public enum Endpoint {
    static let clientId = "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE"
    static let clientSecret = "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"
    case login(email: String, password: String)
    case loginWithToken(token: String)
    case logout(token: String)
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
        }
    }
    
    public var method: Moya.Method {
        .post
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
            return .requestParameters(parameters: ["grant_type": "refresh_token",
                                                   "token": token,
                                                   "client_id": Self.clientId,
                                                   "client_secret": Self.clientSecret],
                                      encoding: JSONEncoding.default)
        case .loginWithToken(let token):
            return .requestParameters(parameters: ["token": token,
                                                   "client_id": Self.clientId,
                                                   "client_secret": Self.clientSecret],
                                      encoding: JSONEncoding.default)
        }
        
    }
    
    public var headers: [String : String]? {
        nil
    }
    
    public var sampleData: Data {
        var fileName: String?
        switch self {
        case .logout:
            fileName = "LogoutResponse"
        case .login, .loginWithToken:
            fileName = "LoginResponse"
        }
        guard let fileName else {
            return Data()
        }
        return Self.getSampleData(fileName: fileName)
    }
    
    
}

private extension Endpoint {
    static func getSampleData(fileName: String) -> Data {
        // Get the path to the LoginResponse.json file in the main bundle
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            // Create a URL from the file path
            let fileURL = URL(fileURLWithPath: path)
            do {
                
                // Read the contents of the file into Data
                return try Data(contentsOf: fileURL)
            } catch {
                print("Error during read\(error)")
            }
             
        } else {
            print(".json file not found in the main bundle.")
        }
        return Data()
    }
}
