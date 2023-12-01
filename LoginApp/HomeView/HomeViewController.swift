//
//  HomeViewController.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import Foundation

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray
        return pageControl
    }()

    private let startSurveyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Take Survey", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(startSurvey), for: .touchUpInside)
        return button
    }()

    private let onboardingPages: [OnboardingPage] = [
        OnboardingPage(coverUrl: "", title: "Page 1", description: "Description 1"),
        OnboardingPage(coverUrl: "", title: "Page 2", description: "Description 2"),
        OnboardingPage(coverUrl: "", title: "Page 3", description: "Description 3"),
        // Add more pages as needed
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .white

        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        for (index, page) in onboardingPages.enumerated() {
            let pageView = OnboardingPageView()
            pageView.configure(with: page)
            scrollView.addSubview(pageView)
            pageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(view.frame.width * CGFloat(index))
                make.top.bottom.width.height.equalTo(view)
            }
        }

        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(onboardingPages.count), height: view.frame.height)

        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        pageControl.numberOfPages = onboardingPages.count

        view.addSubview(startSurveyButton)
        startSurveyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        startSurveyButton.isHidden = true
    }

    @objc private func startSurvey() {
        print("Start Survey Button Tapped")
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        startSurveyButton.isHidden = pageIndex < CGFloat(onboardingPages.count - 1)
    }
}
