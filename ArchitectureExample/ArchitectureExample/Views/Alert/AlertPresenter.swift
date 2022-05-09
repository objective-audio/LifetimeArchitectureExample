//
//  AlertPresenter.swift
//

@MainActor
final class AlertPresenter<Router: RouterForAlertPresenter> {
    let content: AlertContent<Router.AlertID>
    
    private weak var router: Router?
    
    init(content: AlertContent<Router.AlertID>,
         router: Router) {
        self.content = content
        self.router = router
    }
    
    func alertWillHandleAction() {
        self.router?.hideAlert(id: self.content.id)
        self.router = nil
    }
}
