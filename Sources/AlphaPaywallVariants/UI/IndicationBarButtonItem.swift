//
// Copyright © 2023 Alpha Apps LLC. All rights reserved.
//

import Foundation
import UIKit

final class IndicationBarButtonItem: UIBarButtonItem {
    
    var indicationColor: UIColor = UIColor.label
    
    func startAnimating() {
        isEnabled = false
        let activityIndicatorView = makeActivityIndicatorView()
        let width = getWidthForIndicator()
        activityIndicatorView.snp.removeConstraints()
        activityIndicatorView.snp.makeConstraints { make in
            make.width.equalTo(width)
        }
        customView = activityIndicatorView
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        let activityIndicatorView = customView as? UIActivityIndicatorView
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
        customView = nil
        isEnabled = true
    }
    
    private func getWidthForIndicator() -> CGFloat {
        guard let view = self.value(forKey: "view") as? UIView else {
            return 30
        }
        
        let frameWidth = view.frame.width
        return max(frameWidth, 30)
    }
    
    private func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(frame: .zero)
        indicatorView.color = indicationColor
        return indicatorView
    }
}
