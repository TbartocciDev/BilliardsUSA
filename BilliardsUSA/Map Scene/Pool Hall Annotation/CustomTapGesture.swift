//
//  CustomTapGesture.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 3/18/21.
//

import UIKit

class UnfollowTapGestureRecognizer: UIGestureRecognizer {
    var touchesBeganCallback: ((Set<UITouch>, UIEvent) -> Void)?

        override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
            self.cancelsTouchesInView = false
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesBegan(touches, with: event)
            touchesBeganCallback?(touches, event)
        }

        override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }

        override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }
}
