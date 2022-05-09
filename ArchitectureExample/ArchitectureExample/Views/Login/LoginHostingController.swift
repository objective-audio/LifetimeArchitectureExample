//
//  LoginHostingController.swift
//

import UIKit
import SwiftUI

final class LoginHostingController: UIHostingController<LoginView<LoginPresenter>> {
    init(presenter: LoginPresenter) {
        super.init(rootView: .init(presenter: presenter))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
