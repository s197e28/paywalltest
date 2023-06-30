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
    
    public var titleText: String? {
        didSet {
            guard let text = titleText, text.isEmpty == false else {
                titleLabel.attributedText = nil
                return
            }
            
            let texts = text.components(separatedBy: "\n")
            let attributedString = NSMutableAttributedString(string: "")
            
            if let text = texts.first {
                attributedString.append(NSAttributedString(string: text))
                let range = NSRange(location: 0, length: text.count)
                attributedString.addAttribute(
                    .font,
                    value: UIFont.preferredFont(forTextStyle: .title1, weight: .bold),
                    range: range
                )
                attributedString.addAttribute(
                    .foregroundColor,
                    value: accentColor,
                    range: NSRange(location: 0, length: text.count)
                )
            }
            
            if texts.count > 1 {
                let text = texts[1..<texts.count].joined(separator: "\n")
                attributedString.append(NSAttributedString(string: "\n\(text)"))
                let range = NSRange(location: attributedString.string.count - text.count, length: text.count)
                attributedString.addAttribute(
                    .font,
                    value: UIFont.preferredFont(forTextStyle: .title1, weight: .bold),
                    range: range
                )
                attributedString.addAttribute(
                    .foregroundColor,
                    value: primaryLabelColor,
                    range: range
                )
            }
            
            titleLabel.attributedText = attributedString
        }
    }
    
    public var featuresTitle: String? {
        didSet {
            featuresTitleLabel.text = featuresTitle
        }
    }
    
    public var productsTitle: String? {
        didSet {
            productsTitleLabel.text = productsTitle
        }
    }
    
    public var applyActionText: String? {
        didSet {
            guard let text = applyActionText, text.isEmpty == false else {
                continueButton.attributedTitle = nil
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
            
            continueButton.attributedTitle = attributedString
        }
    }
    
    public var restoreActionText: String? {
        didSet {
            restoreBarButton.title = restoreActionText
        }
    }
    
    public var featureItems: [FeatureItemViewModel] = [] {
        didSet {
            let widths = featureItems.map({
                FeatureCollectionViewCell.calculateWidth(text: $0.title)
            })
            
            featureCollectionViewOffset = widths.max() ?? 0
            featuresCollectionView.reloadData()
        }
    }
    
    public var productItems: [ProductItemViewModel] = [] {
        didSet {
            productsCollectionView.reloadData()
        }
    }
    
    public var benefitItems: [String] = [] {
        didSet {
            for subView in benefitsStackView.arrangedSubviews {
                subView.removeFromSuperview()
            }
            
            for view in benefitItems.map({ makeBenefitView(text: $0) }) {
                benefitsStackView.addArrangedSubview(view)
            }
        }
    }
    
    public var footerItems: [String] = [] {
        didSet {
            for subView in bottomButtonsStackView.arrangedSubviews {
                subView.removeFromSuperview()
            }
            
            for (index, item) in footerItems.enumerated() {
                let button = makeFooterButton(text: item, index: index)
                bottomButtonsStackView.addArrangedSubview(button)
            }
        }
    }
    
    public var selectedProductItemIndex: Int? {
        get {
            guard let indexPath = productsCollectionView.indexPathsForSelectedItems?.first else {
                return nil
            }
            
            return indexPath.item
        } set {
            guard let value = newValue else {
                if let indexPath = productsCollectionView.indexPathsForSelectedItems?.first {
                    productsCollectionView.deselectItem(at: indexPath, animated: false)
                }
                return
            }
            
            productsCollectionView.selectItem(at: IndexPath(item: value, section: 0), animated: false, scrollPosition: [])
        }
    }
    
    public var isRestoreActionIndication: Bool = false {
        didSet {
            closeBarButton.isEnabled = !isRestoreActionIndication
            restoreBarButton.isEnabled = !isRestoreActionIndication
            continueButton.isEnabled = !isRestoreActionIndication
            bottomButtonsStackView.isUserInteractionEnabled = !isRestoreActionIndication
            productsCollectionView.isUserInteractionEnabled = !isRestoreActionIndication
        }
    }
    
    public var isContinueActionIndication: Bool = false {
        didSet {
            closeBarButton.isEnabled = !isContinueActionIndication
            restoreBarButton.isEnabled = !isContinueActionIndication
            continueButton.isEnabled = !isContinueActionIndication
            bottomButtonsStackView.isUserInteractionEnabled = !isContinueActionIndication
            productsCollectionView.isUserInteractionEnabled = !isContinueActionIndication
            
            if isContinueActionIndication {
                continueButton.startIndication()
            } else {
                continueButton.stopIndication()
            }
        }
    }
    
    // MARK: Other properties
    
    private var featureCollectionViewOffset: CGFloat = 0
    
    private lazy var closeBarButton: UIBarButtonItem = {
        return CloseBarButtonItem(color: secondaryLabelColor, target: self, action: #selector(didTapCloseButton))
    }()
    
    private lazy var restoreBarButton: UIBarButtonItem = {
        let buttonItem = IndicationBarButtonItem(title: nil, style: .plain, target: self, action: #selector(didTapRestoreButton))
        buttonItem.tintColor = accentColor
        buttonItem.indicationColor = accentColor
        return buttonItem
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
//        scrollView.alwaysBounceVertical = true
        scrollView.delaysContentTouches = false
        return scrollView
    }()
    
    private lazy var scrollableContentView = UIView()
    
    private lazy var bottomContentView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        label.textColor = primaryLabelColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var featuresTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline, weight: .semibold)
        label.textColor = accentColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var productsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .semibold)
        label.textColor = primaryLabelColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var continueButton: IncidactionButton = {
        let button = IncidactionButton()
        button.indicationColor = primaryLabelColor
        button.setTitleColor(primaryLabelColor, for: .normal)
        button.setBackgroundColor(color: accentColor, forState: .normal)
        button.setBackgroundColor(color: accentColor.withAlphaComponent(0.7), forState: .disabled)
        button.setBackgroundColor(color: accentColor.withAlphaComponent(0.7), forState: .highlighted)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var benefitsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var bottomButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var featuresCollectionViewLayout: UICollectionViewLayout = {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private lazy var featuresCollectionView: UICollectionView = {
        let collectionView = ContentSizedCollectionView(frame: .zero, collectionViewLayout: featuresCollectionViewLayout)
        collectionView.register(
            FeatureCollectionViewCell.self,
            forCellWithReuseIdentifier: FeatureCollectionViewCell.identifier
        )
        collectionView.allowsSelection = false
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var productsCollectionViewLayout: UICollectionViewLayout = {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(55)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(55)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private lazy var productsCollectionView: UICollectionView = {
        let collectionView = ContentSizedCollectionView(frame: .zero, collectionViewLayout: productsCollectionViewLayout)
        collectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = primaryLabelColor
        return view
    }()
    
    // MARK: Overridden methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    open func didSelectProductItem(_ viewModel: ProductItemViewModel) { }
    
    open func didTapFooterItem(withIndex index: Int) { }
    
    open func didTapClose() { }
    
    open func didTapContinue() { }
    
    open func didTapRestore() { }
    
    public func presentLoadingState() {
        guard activityIndicatorView.superview == nil else {
            return
        }
        
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicatorView.startAnimating()
        
        navigationItem.rightBarButtonItem = nil
        scrollView.isHidden = true
    }
    
    public func presentContentState() {
        if activityIndicatorView.superview != nil {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.removeFromSuperview()
            activityIndicatorView.snp.removeConstraints()
        }
        
        navigationItem.rightBarButtonItem = restoreBarButton
        scrollView.isHidden = false
    }
    
    // MARK: Other methods
    
    private func setupUI() {
        view.backgroundColor = contentBackgroundColor
        
        navigationItem.leftBarButtonItem = closeBarButton
        navigationItem.rightBarButtonItem = restoreBarButton
        
        scrollableContentView.addSubview(titleLabel)
        scrollableContentView.addSubview(featuresTitleLabel)
        scrollableContentView.addSubview(featuresCollectionView)
        
        bottomContentView.addSubview(productsTitleLabel)
        
        bottomContentView.addSubview(productsCollectionView)
        bottomContentView.addSubview(continueButton)
        bottomContentView.addSubview(benefitsStackView)
        bottomContentView.addSubview(bottomButtonsStackView)
        
        scrollView.addSubview(scrollableContentView)
        scrollView.addSubview(bottomContentView)
        
        view.addSubview(scrollView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        featuresTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        featuresCollectionView.snp.makeConstraints { make in
            make.top.equalTo(featuresTitleLabel.snp.bottom).offset(24)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        productsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(productsCollectionView.snp.top).offset(-4)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        productsCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(continueButton.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(benefitsStackView.snp.top).offset(-15)
        }
        
        benefitsStackView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButtonsStackView.snp.top).offset(-19)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        bottomButtonsStackView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomContentView.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
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
    
    @objc private func didTapContinueButton() {
        didTapContinue()
    }
    
    @objc private func didTapRestoreButton() {
        didTapRestore()
    }
    
    private func makeFooterButton(text: String, index: Int) -> UIButton {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat.leastNonzeroMagnitude, bottom: 0, right: 0)
        button.setTitleColor(secondaryLabelColor, for: .normal)
        button.setTitleColor(secondaryLabelColor.withAlphaComponent(0.7), for: .highlighted)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        button.setTitle(text, for: .normal)
        button.addAction { [weak self] in
            self?.didTapFooterItem(withIndex: index)
        }
        return button
    }
    
    private func makeBenefitView(text: String) -> UIView {
        let view = UIView()
        
        let imageView = UIImageView(
            image: UIImage(systemName: "checkmark")?
                .applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 13)))?
                .withTintColor(accentColor, renderingMode: .alwaysOriginal)
        )
        
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
        label.textColor = primaryLabelColor
        label.text = text
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(4)
            make.top.bottom.right.equalToSuperview()
        }
        
        return view
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        continueButton.setBackgroundColor(color: accentColor, forState: .normal)
        continueButton.setBackgroundColor(color: accentColor.withAlphaComponent(0.7), forState: .highlighted)
    }
}

extension SimplyPaywallViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == productsCollectionView else {
            return
        }
        
        didSelectProductItem(productItems[indexPath.item])
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case featuresCollectionView:
            return featureItems.count > 0 ? 1 : 0
        case productsCollectionView:
            return productItems.count > 0 ? 1 : 0
        default:
            fatalError()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case featuresCollectionView:
            return featureItems.count
        case productsCollectionView:
            return productItems.count
        default:
            fatalError()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case featuresCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeatureCollectionViewCell.identifier, for: indexPath) as? FeatureCollectionViewCell else {
                fatalError()
            }
            let itemViewModel = featureItems[indexPath.item]
            
            cell.primaryLabelColor = primaryLabelColor
            cell.horizontalOffset = (collectionView.bounds.width - featureCollectionViewOffset) / 2
            
            cell.titleText = itemViewModel.title
            cell.iconImage = itemViewModel.image
            
            return cell
        case productsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
                fatalError()
            }
            let itemViewModel = productItems[indexPath.item]
            
            cell.contentBackgroundColor = contentBackgroundColor
            cell.accentColor = accentColor
            cell.primaryLabelColor = primaryLabelColor
            cell.secondaryLabelColor = secondaryLabelColor
            
            cell.titleText = itemViewModel.title
            cell.descriptionText = itemViewModel.description
            
            return cell
        default:
            fatalError()
        }
    }
}

extension SimplyPaywallViewController {
    
    public struct FeatureItemViewModel {
        
        let title: String
        
        let image: UIImage
        
        public init(title: String, image: UIImage) {
            self.title = title
            self.image = image
        }
    }
    
    public struct ProductItemViewModel {
        
        public let id: String
        
        public let title: String
        
        public let description: String
        
        public init(id: String, title: String, description: String) {
            self.id = id
            self.title = title
            self.description = description
        }
    }
}
