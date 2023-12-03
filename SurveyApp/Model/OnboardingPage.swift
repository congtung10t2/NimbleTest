//
//  OnboardingPage.swift
//  SurveyApp
//
//  Created by tungaptive on 01/12/2023.
//

struct OnboardingPage: Codable {
    let coverUrl: String
    let title: String
    let description: String
}

extension OnboardingPage {
    init(survey: Survey) {
        self.init(coverUrl: survey.attributes.coverImageUrl, title: survey.attributes.title, description: survey.attributes.description)
    }
}
