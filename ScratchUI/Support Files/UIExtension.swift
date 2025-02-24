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

    fileprivate func unwrap<Output: ReuseIdentifiable, Input: ReuseIdentifiable>(item: Input) -> Output {
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


@nonobjc extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        }

        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    /// Utility method to add a `UIViewController` instance to a `UIView`.
    ///
    /// Calls all necessary methods for adding a child view controller and set the constraints
    /// between the views.
    ///
    /// - Parameters:
    ///   - viewController: `UIViewController` instance that will be added to `contentView`.
    ///   - contentView: `UIView` that will add the `childViewController` as its subview.
    func add(childViewController viewController: UIViewController, to contentView: UIView) {
        let matchParentConstraints = [
            viewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate(matchParentConstraints)
        viewController.didMove(toParent: self)
    }
}
