//
//  LoginView.swift
//

import SwiftUI

struct LoginView<Presenter: PresenterForLoginView>: View {
    @State private var accountId: String = ""
    @ObservedObject private var presenter: Presenter
    
    init(presenter: Presenter) {
        self.accountId = presenter.accountId
        self.presenter = presenter
    }
    
    var body: some View {
        VStack {
            TextField(Localized.loginAccountIdPlaceholder.key,
                      text: $accountId,
                      onCommit: { presenter.login() })
                .textFieldStyle(.roundedBorder)
                .padding()
                .onChange(of: accountId) { value in
                    presenter.accountId = value
                }
                .disabled(presenter.isTextFieldDisabled)
            
            if presenter.isActivityIndicatorEnabled {
                ActivityIndicator()
            }
            
            Button {
                presenter.login()
            } label: {
                Text(Localized.loginButtonTitle.key)
            }
            .padding()
            .disabled(presenter.isLoginButtonDisabled)
            
            if presenter.isCancelButtonEnabled {
                Button {
                    presenter.cancel()
                } label: {
                    Text(Localized.loginCancelButtonTitle.key)
                }

            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    private class PresenterStub: PresenterForLoginView {
        var accountId: String = ""
        
        let isTextFieldDisabled = false
        let isActivityIndicatorEnabled = true
        let isLoginButtonDisabled = false
        let isCancelButtonEnabled = true
        
        func login() {}
        func cancel() {}
    }
    
    static var previews: some View {
        LoginView(presenter: PresenterStub())
            .environment(\.locale, .init(identifier: "ja"))
    }
}
