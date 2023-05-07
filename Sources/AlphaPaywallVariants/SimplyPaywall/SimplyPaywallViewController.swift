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
    
    // MARK: Overridden properties
    
    open var accentColor: UIColor = UIColor.blue
    
    open var featureOptions: [FeatureOption] = []
    
    // MARK: Public properties
    
    public var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    // MARK: Other properties
    
    private lazy var closeBarButton: UIBarButtonItem = {
        let image = UIImage(systemName: "xmark.circle.fill")?
            .withTintColor(accentColor)
            .withRenderingMode(.alwaysOriginal)
//            .withConfiguration(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 40, weight: .semibold)))
        
        return UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentView = UIView()
    
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
        button.backgroundColor = accentColor
        return button
    }()
    
    // MARK: Overridden methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    open func handleClose() { }
    
    // MARK: Other methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = closeBarButton
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(applyButton)
        
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        applyButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(scrollView.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().priority(.medium)
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    @objc private func didTapClose() {
        handleClose()
    }
}

extension SimplyPaywallViewController {
    
    public struct FeatureOption {
        
        let name: String
        
        let image: UIImage
    }
}
