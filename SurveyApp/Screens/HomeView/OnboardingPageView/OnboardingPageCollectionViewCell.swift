//
//  OnboardingPageCollectionViewCell.swift
//  SurveyApp
//
//  Created by tungaptive on 01/12/2023.
//

import UIKit
import SnapKit
import Kingfisher

class OnboardingPageCollectionViewCell: UICollectionViewCell {
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 28)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.alpha = 0.7
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        coverImageView.backgroundColor = .clear
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(54)
            make.leading.equalToSuperview().offset(20)
        }
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
    }
    
    func configure(with page: OnboardingPage) {
        if let url = URL(string: page.coverUrl) {
            coverImageView.kf.setImage(with: url)
        }
        titleLabel.text = page.title
        descriptionLabel.text = page.description
        
    }
}
