//
//  ViewController.swift
//  SurveyApp
//
//  Created by tungaptive on 29/11/2023.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let logoView: UIView = {
        let logoView = UIView()
        return logoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        addBackground()
        addContentView()
        addLogo()
    }
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let dimView: UIView = {
        let blurView = UIView()
        blurView.backgroundColor = .black
        blurView.alpha = 0.2
        return blurView
    }()
    
    
    func addContentView() {
        view.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    func addLogo() {
        view.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
            make.bottom.equalTo(contentStackView.snp.top)
            make.centerX.equalToSuperview()
        }
        let imageView = UIImageView(image: UIImage(named: "ic-logo"))
        imageView.contentMode =  .scaleAspectFit
        imageView.clipsToBounds = true
        logoView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func addBackground(){
        let imageView = UIImageView(image: UIImage(named: "bg-overlay"))
        imageView.contentMode =  .scaleToFill
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addDimView() {
        view.addSubview(dimView)
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func showLoading() {
        dimView.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        dimView.isHidden = true
        loadingIndicator.stopAnimating()
    }
}

