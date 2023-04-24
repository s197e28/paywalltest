//
//  PaywallBuilder.swift
//  
//
//  Created by Nikita Morozov on 4/24/23.
//

import Foundation
import UIKit

public final class PaywallBuilder {
    
    public init() { }
    
    public func makeSimplyPaywall() -> UIViewController {
        let viewController = SimplyPaywallViewController()
        viewController.titleText = "Get the complete and easy Invoice experience with the PRO subscription"
        return viewController
    }
}
