//
// 
//

import Foundation
import UIKit

final class CloseBarButtonItem: UIBarButtonItem {
    
    init(color: UIColor, target: Any, action: Selector) {
        super.init()
        
        let image = UIImage(systemName: "xmark.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 28, weight: .semibold)))
            .withTintColor(color)
            .withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        self.customView = button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
