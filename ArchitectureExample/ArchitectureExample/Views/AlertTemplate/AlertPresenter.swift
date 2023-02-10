//
//  AlertPresenter.swift
//

@MainActor
final class AlertPresenter<Interactor: InteractorForAlertPresenter> {
    let content: AlertContent<Interactor.AlertID>

    private weak var interactor: Interactor?

    init(interactor: Interactor) {
        self.content = interactor.content
        self.interactor = interactor
    }

    func alertWillHandleAction() {
        self.interactor?.finalize()
        self.interactor = nil
    }
}
