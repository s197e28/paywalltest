//
//  ExampleSimplyPaywallViewController.swift
//  Example
//
//  Created by Nikita Morozov on 5/12/23.
//

import Foundation
import UIKit
import AlphaPaywallVariants

final class ExampleSimplyPaywallViewController: SimplyPaywallViewController {
    
    override var contentBackgroundColor: UIColor {
        UIColor(named: "Background/Primary")!
    }
    
    override var accentColor: UIColor {
        UIColor(named: "Default/Primary")!
    }
    
    override var primaryLabelColor: UIColor {
        UIColor(named: "Label/Primary")!
    }
    
    override var secondaryLabelColor: UIColor {
        UIColor(named: "Label/Secondary")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText = "Get the complete and easy Invoice experience with the PRO subscription"
        additionalBarActionText = "Restore"
        privacyPolicyText = "Privacy Policy"
        termsOfUseText = "Terms of Use"
        applyActionText = "Continue with Free One-Week Trial\nthen $169.99/year"
        
        featureOptions = [
            Self.FeatureOption(name: "Manage clients", image: UIImage(systemName: "person.2")!),
            Self.FeatureOption(name: "Create invoices and estimates", image: UIImage(systemName: "doc.plaintext")!),
            Self.FeatureOption(name: "Send unlimited documents", image: UIImage(systemName: "square.and.arrow.up")!),
            Self.FeatureOption(name: "Work without ads or limits", image: UIImage(systemName: "checkmark.seal")!)
        ]
    }
    
    override func didTapClose() {
        self.dismiss(animated: true)
    }
}
