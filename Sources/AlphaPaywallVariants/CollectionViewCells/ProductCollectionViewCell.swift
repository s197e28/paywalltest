//
// 
//

import Foundation
import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "ProductCollectionViewCell"
    
    var contentBackgroundColor: UIColor = UIColor.systemBackground {
        didSet {
            borderBackgroundView.backgroundColor = contentBackgroundColor
        }
    }
    
    var accentColor: UIColor = UIColor.blue {
        didSet {
            borderView.layer.borderColor = accentColor.cgColor
        }
    }
    
    var primaryLabelColor: UIColor = UIColor.label {
        didSet {
            titleLabel.textColor = primaryLabelColor
        }
    }
    
    var secondaryLabelColor: UIColor = UIColor.secondaryLabel {
        didSet {
            descriptionLabel.textColor = secondaryLabelColor
        }
    }
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline, weight: .semibold)
        label.textColor = primaryLabelColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        label.textColor = primaryLabelColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.layer.borderColor = accentColor.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 12
        view.layer.opacity = 0.2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var borderBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = contentBackgroundColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                borderView.layer.opacity = 1
            } else {
                borderView.layer.opacity = 0.2
            }
        }
    }
    
    private func setupUI() {
        contentView.addSubview(borderBackgroundView)
        contentView.addSubview(borderView)
        contentView.addSubview(contentStackView)
        
        borderBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
