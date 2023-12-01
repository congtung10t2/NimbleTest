//
//  OnboardingPageView.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import UIKit
import SnapKit
import Kingfisher

class OnboardingPageView: UIView {
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    func configure(with page: OnboardingPage) {
        if let url = URL(string: page.coverUrl) {
            coverImageView.kf.setImage(with: url)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
