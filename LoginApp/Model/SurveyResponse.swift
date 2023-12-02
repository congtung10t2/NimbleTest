//
//  SurveyResponse.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation

// MARK: - SurveyList
struct SurveyList: Codable {
    let data: [Survey]
    let meta: SurveyMeta
}

// MARK: - Survey
struct Survey: Codable {
    let id, type: String
    let attributes: SurveyAttributes
}

// MARK: - SurveyAttributes
struct SurveyAttributes: Codable {
    let title, description: String
    let thankEmailAboveThreshold: String?
    let thankEmailBelowThreshold: String?
    let isActive: Bool
    let coverImageUrl: String
    let createdAt: String?
    let activeAt: String?
    let inactiveAt: String?
    let surveyType: String
}

// MARK: - Meta
struct SurveyMeta: Codable {
    let page, pages, pageSize, records: Int
}

enum SurveyResult {
    case success(SurveyList)
    case failure(Error)
    case errorResponse(ErrorResponse)
}
