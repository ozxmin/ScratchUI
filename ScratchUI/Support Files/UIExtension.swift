//
//  Extensions.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 21/08/24.
//

import UIKit

protocol ReuseIdentifiable: UIView { }

extension ReuseIdentifiable {
    static var id: String {
        String(describing: Self.self)
    }
}

extension UITableViewCell: ReuseIdentifiable { }
extension UICollectionViewCell: ReuseIdentifiable { }

// MARK: - DequeueableConsumer

protocol DequeueableConsumer {
    func dequeueItem<T: ReuseIdentifiable>(for indexPath: IndexPath) -> T
    func dequeueReusable<U: ReuseIdentifiable>(index: IndexPath) -> U
}

extension DequeueableConsumer {
    func dequeueItem<T: ReuseIdentifiable>(for indexPath: IndexPath) -> T {
        dequeueReusable(index: indexPath)
    }

    func unwrap<Output: ReuseIdentifiable, Input: ReuseIdentifiable>(item: Input) -> Output {
        guard let casted = item as? Output else {
            fatalError(#function)
        }
        return casted
    }
}

extension UITableView: DequeueableConsumer {
    func dequeueReusable<U: ReuseIdentifiable>(index: IndexPath) -> U {
         unwrap(item: self.dequeueReusableCell(withIdentifier: U.id, for: index))
    }
}

extension UICollectionView: DequeueableConsumer {
    func dequeueReusable<U: ReuseIdentifiable>(index: IndexPath) -> U {
        unwrap(item: self.dequeueReusableCell(withReuseIdentifier: U.id, for: index))
    }
}

// MARK: - UIImage

extension UIImageView {
    func applyCircleMask() {
        let circleRadius = min(self.frame.size.width, self.frame.size.height) / 2
        self.layer.cornerRadius = circleRadius
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 2
        self.clipsToBounds = true
    }
}
