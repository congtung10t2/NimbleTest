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
    let meta: Meta
}

// MARK: - Survey
struct Survey: Codable {
    let id, type: String
    let attributes: SurveyAttributes
}

// MARK: - SurveyAttributes
struct SurveyAttributes: Codable {
    let title, description, thankEmailAboveThreshold, thankEmailBelowThreshold: String?
    let isActive: Bool
    let coverImageURL: String
    let createdAt, activeAt, inactiveAt: String
    let surveyType: String
}

// MARK: - Meta
struct Meta: Codable {
    let page, pages, pageSize, records: Int
}
