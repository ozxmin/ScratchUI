//
//  Extensions.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 21/08/24.
//

import UIKit

extension UIView {
    static var identifier: String {
        String(describing: Self.self)
    }
}


extension UIImageView {
    func applyCircleMask() {
        let circleRadius = min(self.frame.size.width, self.frame.size.height) / 2
        self.layer.cornerRadius = circleRadius
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 2
        self.clipsToBounds = true
    }
}
