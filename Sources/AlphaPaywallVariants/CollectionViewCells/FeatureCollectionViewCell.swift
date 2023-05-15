//
//  FeatureCollectionViewCell.swift
//  
//
//  Created by Nikita Morozov on 5/13/23.
//

import Foundation
import UIKit

final class FeatureCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "FeatureCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
