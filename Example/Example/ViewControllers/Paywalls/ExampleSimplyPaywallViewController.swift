//
// Copyright © 2023 Alpha Apps LLC. All rights reserved.
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
        
        restoreActionText = "Restore"
        
        titleText = "Unlimited Documents\nConvert as many files as you want"
        featuresTitle = "Unlock all premium features:"
        applyActionText = "Continue with Free One-Week Trial\nthen $169.99/year"
        
        productsTitle = "Free for 3 days. After trial ends 3.99/week."
        
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
            Self.ProductItemViewModel(id: "1", title: "Start 3-day free trial", description: "then $39.99/year. Cancel anytime"),
            Self.ProductItemViewModel(id: "2", title: "Get Monthly Subscription", description: "$9.99/month. Cancel anytime"),
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
        
        selectedProductItemIndex = 1
    }
    
    override func didSelectProductItem(_ viewModel: SimplyPaywallViewController.ProductItemViewModel) {
        print("Select product item with id = \(viewModel.id)")
        
        applyActionText = "Continue with Trial\nthen $200.99/year"
        productsTitle = "After trial ends"
        benefitItems = ["No benefits", "Can't cancel"]
    }
    
    override func didTapFooterItem(withIndex index: Int) {
        print("Tap footer item with index = \(index)")
    }
    
    override func didTapClose() {
        self.dismiss(animated: true)
    }
    
    override func didTapContinue() {
        print("Tap continue button")
        
        isContinueActionIndication = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isContinueActionIndication = false
        }
    }
    
    override func didTapRestore() {
        print("Tap restore button")
        
        isRestoreActionIndication = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isRestoreActionIndication = false
        }
    }
}
