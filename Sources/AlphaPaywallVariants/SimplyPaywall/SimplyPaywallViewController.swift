//
//  SimplyPaywallViewController.swift
//  
//
//  Created by Nikita Morozov on 4/24/23.
//

import Foundation
import UIKit
import SnapKit

open class SimplyPaywallViewController: UIViewController {
    
    // MARK: Colors
    
    open var contentBackgroundColor: UIColor {
        UIColor.systemBackground
    }
    
    open var accentColor: UIColor {
        UIColor.blue
    }
    
    open var primaryLabelColor: UIColor {
        UIColor.label
    }
    
    open var secondaryLabelColor: UIColor {
        UIColor.red
    }
    
    // MARK: Public properties
    
    public var additionalBarActionText: String? {
        didSet {
            guard let text = additionalBarActionText, text.isEmpty == false else {
                navigationItem.leftBarButtonItem = nil
                return
            }
            
            additionalBarButton.title = text
            navigationItem.leftBarButtonItem = additionalBarButton
        }
    }
    
    public var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    public var privacyPolicyText: String? {
        didSet {
            privacyPolicyButton.setTitle(privacyPolicyText, for: .normal)
        }
    }
    
    public var termsOfUseText: String? {
        didSet {
            termsOfUseButton.setTitle(termsOfUseText, for: .normal)
        }
    }
    
    public var applyActionText: String? {
        didSet {
            guard let text = applyActionText, text.isEmpty == false else {
                applyButton.setAttributedTitle(nil, for: .normal)
                return
            }
            
            let texts = text.components(separatedBy: "\n")
            let attributedString = NSMutableAttributedString(string: "")
            
            if let text = texts.first {
                attributedString.append(NSAttributedString(string: text))
                attributedString.addAttribute(
                    .font,
                    value: UIFont.preferredFont(forTextStyle: .headline, weight: .semibold),
                    range: NSRange(location: 0, length: text.count)
                )
            }
            
            if texts.count > 1 {
                let text = texts[1..<texts.count].joined(separator: "\n")
                attributedString.append(NSAttributedString(string: "\n\(text)"))
                attributedString.addAttribute(
                    .font,
                    value: UIFont.preferredFont(forTextStyle: .caption1),
                    range: NSRange(location: attributedString.string.count - text.count, length: text.count)
                )
            }
            
            applyButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    public var featureOptions: [FeatureOption] = [] {
        didSet {
            featureCollectionView.reloadData()
        }
    }
    
    // MARK: Other properties
    
    private lazy var closeBarButton: UIBarButtonItem = {
        let image = UIImage(systemName: "xmark.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 28, weight: .semibold)))
            .withTintColor(UIColor(red: 60 / 255, green: 60 / 255, blue: 57 / 255, alpha: 0.18))
            .withRenderingMode(.alwaysOriginal)
        
        return UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton)
        )
    }()
    
    private lazy var additionalBarButton: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: self,
            action: #selector(didTapAdditionalBarButton)
        )
        buttonItem.tintColor = accentColor
        return buttonItem
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var scrollableContentView = UIView()
    
    private lazy var bottomContentView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundColor(color: accentColor, forState: .normal)
        button.setBackgroundColor(color: accentColor.withAlphaComponent(0.7), forState: .highlighted)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapApplyButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat.leastNonzeroMagnitude, bottom: 0, right: 0)
        button.setTitleColor(secondaryLabelColor, for: .normal)
        button.setTitleColor(secondaryLabelColor.withAlphaComponent(0.7), for: .highlighted)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        return button
    }()
    
    private lazy var termsOfUseButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat.leastNonzeroMagnitude, bottom: 0, right: 0)
        button.setTitleColor(secondaryLabelColor, for: .normal)
        button.setTitleColor(secondaryLabelColor.withAlphaComponent(0.7), for: .highlighted)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        return button
    }()
    
    private lazy var bottonButtonsContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [privacyPolicyButton, termsOfUseButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var featureCollectionViewLayout: UICollectionViewLayout = {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(62)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(62)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private lazy var featureCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: featureCollectionViewLayout)
        collectionView.register(
            FeatureCollectionViewCell.self,
            forCellWithReuseIdentifier: FeatureCollectionViewCell.identifier
        )
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
//        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    // MARK: Overridden methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    open func didTapClose() { }
    
    open func didTapAdditionalAction() { }
    
    open func didTapApply() { }
    
    // MARK: Other methods
    
    private func setupUI() {
        view.backgroundColor = contentBackgroundColor
        
        navigationItem.rightBarButtonItem = closeBarButton
        
        scrollableContentView.addSubview(titleLabel)
        scrollableContentView.addSubview(featureCollectionView)
        
        bottomContentView.addSubview(applyButton)
        bottomContentView.addSubview(bottonButtonsContainer)
        
        scrollView.addSubview(scrollableContentView)
        scrollView.addSubview(bottomContentView)
        
        view.addSubview(scrollView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        featureCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(350)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        applyButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalTo(privacyPolicyButton.snp.top).offset(-24)
        }
        
        bottonButtonsContainer.snp.makeConstraints { make in
            make.bottom.equalTo(bottomContentView.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.left.greaterThanOrEqualTo(scrollView.snp.left).offset(16)
            make.right.lessThanOrEqualTo(scrollView.snp.right).offset(-16)
        }
        
        scrollableContentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().priority(.medium)
            make.edges.equalToSuperview()
        }
        
        bottomContentView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.equalTo(scrollView.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    @objc private func didTapCloseButton() {
        didTapClose()
    }
    
    @objc private func didTapAdditionalBarButton() {
        didTapAdditionalAction()
    }
    
    @objc private func didTapApplyButton() {
        didTapApply()
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        applyButton.setBackgroundColor(color: accentColor, forState: .normal)
        applyButton.setBackgroundColor(color: accentColor.withAlphaComponent(0.7), forState: .highlighted)
    }
}

extension SimplyPaywallViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case featureCollectionView:
            return featureOptions.count > 0 ? 1 : 0
        default:
            fatalError()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case featureCollectionView:
            return featureOptions.count
        default:
            fatalError()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case featureCollectionView:
            guard let cell = featureCollectionView.dequeueReusableCell(withReuseIdentifier: FeatureCollectionViewCell.identifier, for: indexPath) as? FeatureCollectionViewCell else {
                fatalError()
            }
            
            return cell
        default:
            fatalError()
        }
    }
}

extension SimplyPaywallViewController {
    
    public struct FeatureOption {
        
        let name: String
        
        let image: UIImage
        
        public init(name: String, image: UIImage) {
            self.name = name
            self.image = image
        }
    }
}
