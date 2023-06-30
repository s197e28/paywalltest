//
// Copyright © 2023 Alpha Apps LLC. All rights reserved.
//

import Foundation
import UIKit

final class ContentSizedCollectionView: UICollectionView {
    
    private var contentSizeObservation: NSKeyValueObservation?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        let cvHeight = heightAnchor.constraint(equalToConstant: 1)
        cvHeight.isActive = true
        contentSizeObservation = self.observe(\.contentSize, options: .new, changeHandler: { (cv, _) in
            cvHeight.constant = cv.collectionViewLayout.collectionViewContentSize.height
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        contentSizeObservation?.invalidate()
    }
}
