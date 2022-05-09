//
//  UIViewController+Child.swift
//

import UIKit

extension UIViewController {
    func replaceChild(_ new: UIViewController?) {
        self.children.first.flatMap { self.dismissChild($0) }
        new.flatMap { self.presentChild($0) }
    }

    func presentChild(_ new: UIViewController,
                      duration: TimeInterval = 0.3) {
        self.addChild(new)
        self.addChildView(new.view)

        new.view.alpha = 0.0

        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .transitionCrossDissolve) {
            new.view.alpha = 1.0
        } completion: { _ in
            new.didMove(toParent: self)
        }
    }

    func dismissChild(_ old: UIViewController,
                      duration: TimeInterval = 0.3) {
        old.willMove(toParent: nil)

        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .transitionCrossDissolve) {
            old.view.alpha = 0.0
        } completion: { _ in
            old.view.removeFromSuperview()
            old.removeFromParent()
        }
    }

    private func addChildView(_ child: UIView) {
        self.view.addSubview(child)

        child.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([child.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     child.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     child.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                     child.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
}
