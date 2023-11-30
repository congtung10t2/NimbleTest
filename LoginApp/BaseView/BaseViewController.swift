//
//  ViewController.swift
//  LoginApp
//
//  Created by tungaptive on 29/11/2023.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        addLogo()
        addContentView()
    }
    
    func addContentView() {
        view.addSubview(contentStackView)
    }
    
    func addLogo() {
        let imageView = UIImageView(image: UIImage(named: "ic-logo"))
        imageView.contentMode =  .scaleAspectFit
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(109)
            } else {
                make.top.equalToSuperview().offset(109)
            }
            make.centerX.equalToSuperview()
        }
    }
    
    func addBackground(){
        let imageView = UIImageView(image: UIImage(named: "bg-overlay"))
        imageView.contentMode =  .scaleToFill
        imageView.center = view.center
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

