//
//  ModalPresenter.swift
//

import Combine

@MainActor
final class ModalPresenter<Modal: ModalConvertible> {
    @CurrentValue private(set) var modal: Modal?
    @CurrentValue private var isSuspended: Bool = false

    private var cancellables: Set<AnyCancellable> = .init()

    init<SourcePublisher: Publisher>(
            sourcePublisher: SourcePublisher
         ) where SourcePublisher.Output == Modal.ModalSource?, SourcePublisher.Failure == Never {
        modalSuspending(input: sourcePublisher,
                        isSuspended: self.$isSuspended,
                        outputType: Modal.self)
        .sink { [weak self] modal in
            // assignでできるならやりたい
            self?.modal = modal
        }
        .store(in: &self.cancellables)
    }
}

extension ModalPresenter: ModalSuspendable {
    func modalWillPresent() {
        self.isSuspended = true
    }

    func modalDidPresent() {
        self.isSuspended = false
    }

    func modalWillDismiss() {
        self.isSuspended = true
    }

    func modalDidDismiss() {
        self.isSuspended = false
    }
}
