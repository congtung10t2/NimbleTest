//
//  MockKeychainSwift.swift
//  SurveyAppTests
//
//  Created by tungaptive on 02/12/2023.
//

import Foundation
import KeychainSwift

@testable import SurveyApp

class MockKeychainSwift: KeychainProtocol {
   
    
    var storage: [String: String] = [:]
    
    func set(_ value: String, forKey key: String, withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
        storage[key] = value
        return true
    }
    
    func delete(_ key: String) -> Bool {
        storage[key] = nil
        return true
    }
    
    func get(_ key: String) -> String? {
        return storage[key]
    }
}
