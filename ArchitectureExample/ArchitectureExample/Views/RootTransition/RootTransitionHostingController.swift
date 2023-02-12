//
//  RootTransitionChildHostingController.swift
//

import SwiftUI

extension RootTransitionChildPresenter: ChildPresenterForRootTransitionView {}
extension RootTransitionModalPresenter: ModalPresenterForRootTransitionView {}

typealias RootTransitionHostingType = RootTransitionView<RootTransitionChildPresenter,
                                                         RootTransitionModalPresenter,
                                                         RootTransitionViewFactory>

final class RootTransitionHostingController: UIHostingController<RootTransitionHostingType> {
    let commandPresenter: RootCommandPresenter

    init(presenter: RootTransitionChildPresenter,
         modalPresenter: RootTransitionModalPresenter,
         commandPresenter: RootCommandPresenter) {
        self.commandPresenter = commandPresenter

        super.init(rootView: .init(childPresenter: presenter,
                                   modalPresenter: modalPresenter))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
