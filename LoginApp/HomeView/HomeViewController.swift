//
//  HomeViewController.swift
//  LoginApp
//
//  Created by tungaptive on 01/12/2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray
        return pageControl
    }()

    private let startSurveyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic-start-survey"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(startSurvey), for: .touchUpInside)
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic-start-survey"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(startSurvey), for: .touchUpInside)
        return button
    }()

    private var onboardingPages: [OnboardingPage] = []

    let viewModel: HomeViewModel

    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }

    func setupData() {
         viewModel.fetchSurveyList() { [weak self] result in
             switch result {
             case .success(let pages):
                 self?.reloadData(pages: pages)
             case .failure(let error):
                 guard let message = (error as? NSError)?.userInfo["message"] else {
                     return
                 }
                 self?.showAlert(title: "Fetching survey failed", message: "\(message)")
             }
         }
    }
    
    func addBackground(){
        let imageView = UIImageView(image: UIImage(named: "bg-home"))
        imageView.contentMode =  .scaleToFill
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func reloadData(pages: [OnboardingPage]) {
        DispatchQueue.main.async {
            self.onboardingPages = pages
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.onboardingPages.count
        }
    }

    private func setupViews() {
        addBackground()
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(OnboardingPageCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingPageCollectionViewCell")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(pageControl)
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        var leadingPageControlOffset = 20
        if #available(iOS 14, *) {
            leadingPageControlOffset = -10
        }
        pageControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingPageControlOffset)
            make.bottom.equalToSuperview().inset(172)
        }

        view.addSubview(startSurveyButton)
        startSurveyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(54)
            make.width.equalTo(56)
            make.height.equalTo(56)
        }
    }

    @objc private func startSurvey() {
        debugPrint("Access page detail \(pageControl.currentPage)")
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingPages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingPageCollectionViewCell", for: indexPath) as? OnboardingPageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: onboardingPages[indexPath.item])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        startSurveyButton.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = view.frame.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        let newX = CGFloat(currentPage) * pageWidth

        if scrollView.contentOffset.x != newX {
            scrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
        }
        startSurveyButton.isHidden = false
        pageControl.currentPage = currentPage
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
