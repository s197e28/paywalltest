//
//  UIFont+Extensions.swift
//  
//
//  Created by Nikita Morozov on 4/24/23.
//

import Foundation
import UIKit

internal extension UIFont {
    
    static func preferredFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        UIFont.preferredFont(forTextStyle: style).with(weight: weight)
    }
    
    private func with(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}
