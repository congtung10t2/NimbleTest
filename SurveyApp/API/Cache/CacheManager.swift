//
//  CacheManager.swift
//  SurveyApp
//
//  Created by tungaptive on 03/12/2023.
//

import Foundation

class CacheManager {

    // Set a directory name for caching
    private static let cacheDirectoryName = "SurveyAppCache"

    // Retrieve the documents directory
    private static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    // Retrieve the cache directory
    private static var cacheDirectory: URL {
        return documentsDirectory.appendingPathComponent(cacheDirectoryName)
    }

    // Check if the cache directory exists, if not, create it
    private static func createCacheDirectoryIfNeeded() {
        do {
            try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            debugPrint("Error creating cache directory: \(error.localizedDescription)")
        }
    }

    // Save data to cache
    static func saveDataToCache<T: Encodable>(_ data: T, fileName: String) {
        createCacheDirectoryIfNeeded()

        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        do {
            let jsonData = try JSONEncoder().encode(data)
            try jsonData.write(to: fileURL, options: .atomic)
        } catch {
            debugPrint("Error saving data to cache: \(error.localizedDescription)")
        }
    }

    // Load data from cache
    static func loadDataFromCache<T: Decodable>(_ type: T.Type, fileName: String) -> T? {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(type, from: data)
            return decodedData
        } catch {
            debugPrint("Error loading data from cache: \(error.localizedDescription)")
            return nil
        }
    }

    // Remove cached data
    static func removeCacheFile(fileName: String) {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }

    // Clear entire cache directory
    static func clearCache() {
        do {
            try FileManager.default.removeItem(at: cacheDirectory)
            createCacheDirectoryIfNeeded()
        } catch {
            debugPrint("Error clearing cache: \(error.localizedDescription)")
        }
    }
}
