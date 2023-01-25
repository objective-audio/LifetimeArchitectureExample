//
//  RootTransitionModalPresenter.swift
//

typealias RootTransitionModalPresenter = ModalPresenter<RootModal>

extension RootModal: ModalConvertible {
    init?(_ subLifetime: RootModalSubLifetime<RootModalFactory>?) {
        switch subLifetime {
        case .alert(let lifetime):
            self = .alert(lifetimeId: lifetime.lifetimeId)
        case .accountEdit(let lifetime):
            self = .accountEdit(lifetimeId: lifetime.lifetimeId)
        case .none:
            return nil
        }
    }
}
