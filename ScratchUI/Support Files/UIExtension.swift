//
//  Extensions.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 21/08/24.
//

import UIKit


protocol ReuseIdentifiable: UIView { }

extension ReuseIdentifiable {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UITableViewCell: ReuseIdentifiable { }


protocol DequeueableConsumer {
    func dequeueItem<T: ReuseIdentifiable>(for indexPath: IndexPath, item: T?) -> T
    func dequeueReusable<U: ReuseIdentifiable>(index: IndexPath) -> U
}

extension DequeueableConsumer {
    func dequeueItem<T: ReuseIdentifiable>(for indexPath: IndexPath, item: T? = nil) -> T {
        let unit: T = dequeueReusable(index: indexPath)
        return unit
    }
}


extension UITableView: DequeueableConsumer {
    func dequeueReusable<U: ReuseIdentifiable>(index: IndexPath) -> U {
        guard let cell = self.dequeueReusableCell(withIdentifier: U.identifier, for: index) as? U else {
            fatalError(#function)
        }
        return cell
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
