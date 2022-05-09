//
//  AccountInfoHostingController.swift
//

import SwiftUI

final class AccountInfoHostingController: UIHostingController<AccountInfoView<AccountInfoPresenter>> {
    private let presenter: AccountInfoPresenter
    
    init(presenter: AccountInfoPresenter) {
        self.presenter = presenter
        super.init(rootView: .init(presenter: presenter))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Localized.accountInfoNavigationTitle.value
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            self.presenter.viewDidDismiss()
        }
        
        super.viewDidDisappear(animated)
    }
}
