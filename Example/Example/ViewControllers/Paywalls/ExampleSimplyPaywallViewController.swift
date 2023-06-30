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
        UIColor(named: "Simply/ContentBackground")!
    }
    
    override var accentColor: UIColor {
        UIColor(named: "Simply/Accent")!
    }
    
    override var primaryLabelColor: UIColor {
        UIColor(named: "Simply/PrimaryLabel")!
    }
    
    override var secondaryLabelColor: UIColor {
        UIColor(named: "Simply/SecondaryLabel")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText = "Unlimited Documents\nConvert as many files as you want"
        featuresTitle = "Unlock all premium features:"
        applyActionText = "Continue with Free One-Week Trial\nthen $169.99/year"
        
        optionsTitle = "Free for 3 days. After trial ends 3.99/week."
        
        featureItems = [
            Self.FeatureItemViewModel(
                title: "Unlimited documents",
                image: UIImage(systemName: "person.2")!
                    .applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 23)))!
                    .withTintColor(accentColor, renderingMode: .alwaysOriginal)
            ),
            Self.FeatureItemViewModel(
                title: "No ads",
                image: UIImage(systemName: "doc.plaintext")!
                    .applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 23)))!
                    .withTintColor(accentColor, renderingMode: .alwaysOriginal)
            ),
            Self.FeatureItemViewModel(
                title: "Faster conversion",
                image: UIImage(systemName: "square.and.arrow.up")!
                    .applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 23)))!
                    .withTintColor(accentColor, renderingMode: .alwaysOriginal)
            ),
        ]
        
        productItems = [
            Self.ProductItemViewModel(title: "Start 3-day free trial", description: "then $39.99/year. Cancel anytime"),
            Self.ProductItemViewModel(title: "Get Monthly Subscription", description: "$9.99/month. Cancel anytime"),
//            Self.ProductItemViewModel(title: "Get Monthly Subscription", description: "$9.99/month. Cancel anytime"),
//            Self.ProductItemViewModel(title: "Get Monthly Subscription", description: "$9.99/month. Cancel anytime")
        ]
        
        benefitItems = [
            "No charge until Oct 20",
            "Cancel anytime"
        ]
        
        footerItems = [
            "Terms of Service",
            "Restore Purchase",
            "Privacy Policy"
        ]
    }
    
    override func didTapClose() {
        self.dismiss(animated: true)
    }
}
