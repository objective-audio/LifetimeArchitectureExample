//
//  LoginView.swift
//

import SwiftUI

struct LoginView<Presenter: PresenterForLoginView>: View {
    @ObservedObject var presenter: Presenter
    // TextFieldをdisableにする時に警告が表示される対策。先にフォーカスを外す
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            TextField(Localized.loginAccountIdPlaceholder.key,
                      text: $presenter.accountId)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    isTextFieldFocused = false
                    presenter.login()
                }
                .focused($isTextFieldFocused)
                .disabled(presenter.isTextFieldDisabled)

            if presenter.isActivityIndicatorEnabled {
                ActivityIndicator()
            }

            Button {
                isTextFieldFocused = false
                presenter.login()
            } label: {
                Text(Localized.loginButtonTitle.key)
            }
            .padding()
            .disabled(presenter.isLoginButtonDisabled)

            if presenter.isCancelButtonEnabled {
                Button {
                    isTextFieldFocused = false
                    presenter.cancel()
                } label: {
                    Text(Localized.loginCancelButtonTitle.key)
                }

            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    private class PreviewPresenter: PresenterForLoginView {
        var accountId: String = ""

        let isTextFieldDisabled = false
        let isActivityIndicatorEnabled = true
        let isLoginButtonDisabled = false
        let isCancelButtonEnabled = true

        func login() {}
        func cancel() {}
    }

    static var previews: some View {
        LoginView(presenter: PreviewPresenter())
            .environment(\.locale, .init(identifier: "ja"))
    }
}
