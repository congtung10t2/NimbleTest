//
//  CacheManagerTests.swift
//  SurveyApp
//
//  Created by tungaptive on 03/12/2023.
//

import Foundation
import XCTest

@testable import SurveyApp

class CacheManagerTests: XCTestCase {

    func testSaveAndLoadData() {
        let dataToCache = ["key": "value"]
        let fileName = "testCacheFile"

        CacheManager.saveDataToCache(dataToCache, fileName: fileName)

        let loadedData: [String: String]? = CacheManager.loadDataFromCache([String : String].self, fileName: fileName)
        XCTAssertNotNil(loadedData)
        XCTAssertEqual(loadedData?["key"], "value")
    }

    // MARK: - Test Remove Cache File

    func testRemoveCacheFile() {
        let dataToCache = ["key": "value"]
        let fileName = "testCacheFile"

        CacheManager.saveDataToCache(dataToCache, fileName: fileName)

        XCTAssertNotNil(CacheManager.loadDataFromCache([String : String].self, fileName: fileName))

        CacheManager.removeCacheFile(fileName: fileName)

        XCTAssertNil(CacheManager.loadDataFromCache([String : String].self, fileName: fileName))
    }

    // MARK: - Test Clear Cache

    func testClearCache() {
        let dataToCache = ["key": "value"]
        let fileName = "testCacheFile"

        CacheManager.saveDataToCache(dataToCache, fileName: fileName)

        XCTAssertNotNil(CacheManager.loadDataFromCache([String : String].self, fileName: fileName))

        CacheManager.clearCache()

        XCTAssertNil(CacheManager.loadDataFromCache([String : String].self, fileName: fileName))
    }

    // MARK: - Performance Test

    func testPerformanceSaveAndLoadData() {
        measure {
            let dataToCache = ["key": "value"]
            let fileName = "performanceTestCacheFile"

            CacheManager.saveDataToCache(dataToCache, fileName: fileName)

            let _ = CacheManager.loadDataFromCache([String : String].self, fileName: fileName)
        }
    }
}
