//
// Copyright © 2023 Alpha Apps LLC. All rights reserved.
//

import Foundation
import UIKit

class IncidactionButton: UIButton {
    
    private var isActivityIndicatorRunning: Bool = false
    private var currentActivityIndicatorView: UIView?
    
    var title: String? {
        didSet {
            guard !isActivityIndicatorRunning else {
                return
            }
            
            setTitle(title, for: .normal)
        }
    }
    
    var attributedTitle: NSAttributedString? {
        didSet {
            guard !isActivityIndicatorRunning else {
                return
            }
            
            setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    var indicationColor: UIColor = UIColor.label
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func startIndication() {
        guard !isActivityIndicatorRunning else {
            return
        }
        
        let indicatorView = getActivityIndicatorView(withColor: indicationColor)
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        if title != nil {
            setTitle(nil, for: .normal)
        } else if attributedTitle != nil {
            setAttributedTitle(nil, for: .normal)
        }
        layoutIfNeeded()
        indicatorView.startAnimating()
        currentActivityIndicatorView = indicatorView
        isActivityIndicatorRunning = true
    }
    
    func stopIndication() {
        guard isActivityIndicatorRunning,
              let indicatorView = currentActivityIndicatorView else {
            return
        }
        
        indicatorView.removeFromSuperview()
        if title != nil {
            setTitle(title, for: .normal)
        } else if attributedTitle != nil {
            setAttributedTitle(attributedTitle, for: .normal)
        }
        isActivityIndicatorRunning = false
    }
    
    private func getActivityIndicatorView(withColor color: UIColor) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
        indicatorView.color = color
        return indicatorView
    }
}
