//
//  UINavigationController+Updation.swift
//

import UIKit

extension UINavigationController {
    enum Updation<Element: Equatable>: Equatable {
        case push(element: Element)
        case pop(toIndex: Int)
        case set(elements: [Element])

        init?(newElements: [Element], oldElements: [Element]) {
            if newElements == oldElements {
                return nil
            } else if newElements.count == 0 {
                self = .set(elements: [])
            } else if newElements.count < oldElements.count,
                      newElements == Array(oldElements[0..<newElements.count]) {
                self = .pop(toIndex: newElements.count - 1)
            } else if oldElements.count > 0,
                      oldElements.count + 1 == newElements.count,
                      oldElements == Array(newElements[0..<oldElements.count]) {
                self = .push(element: newElements[newElements.count - 1])
            } else {
                self = .set(elements: newElements)
            }
        }
    }

    func updateViewControllers<Element: Equatable>(newElements: [Element],
                                                   oldElements: [Element],
                                                   making: (Element) -> UIViewController?) {
        let updation = Updation(newElements: newElements,
                                oldElements: oldElements)

        switch updation {
        case .push(let element):
            making(element).flatMap {
                self.pushViewController($0, animated: true)
            }
        case .pop(let index):
            let target = self.viewControllers[index]
            self.popToViewController(target, animated: true)
        case .set(let elements):
            let viewControllers = elements.compactMap { making($0) }
            self.setViewControllers(viewControllers, animated: true)
        case .none:
            break
        }
    }
}
