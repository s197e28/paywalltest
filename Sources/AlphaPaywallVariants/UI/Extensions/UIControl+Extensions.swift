//
// Copyright © 2023 Alpha Apps LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIControl {
    
    public func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping(() -> Void)) {
        @objc class ClosureSleeve: NSObject {
            let closure: () -> Void
            public init(_ closure: @escaping () -> Void) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
