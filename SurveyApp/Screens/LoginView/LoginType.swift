//
//  LoginType.swift
//  SurveyApp
//
//  Created by tungaptive on 30/11/2023.
//
/// This one is trying to apply factory pattern. seem overkill for this but just to show how this pattern can design flexible UI
enum LoginType {
    case email
    case password
    case button(label: String)
    
    var placeHolder: String {
        switch self {
        case .email:
            return "Email"
        case .password:
            return "Password"
        case .button(let label):
            return label
        }
    }
    
    var isSecure: Bool {
        switch self {
        case .password:
            return true
        default:
            return false
        }
    }
}
