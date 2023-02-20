//
//  RootTransitionChildHostingController.swift
//

import SwiftUI

extension RootChildPresenter: ChildPresenterForRootTransitionView {}
extension RootModalPresenter: ModalPresenterForRootTransitionView {}

typealias RootTransitionHostingType = RootTransitionView<RootChildPresenter,
                                                         RootModalPresenter,
                                                         RootTransitionViewFactory>

final class RootTransitionHostingController: UIHostingController<RootTransitionHostingType> {
    init(sceneLifetimeId: SceneLifetimeId,
         childPresenter: RootChildPresenter,
         modalPresenter: RootModalPresenter) {
        super.init(rootView: .init(sceneLifetimeId: sceneLifetimeId,
                                   childPresenter: childPresenter,
                                   modalPresenter: modalPresenter,
                                   factory: RootTransitionViewFactory.self))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
