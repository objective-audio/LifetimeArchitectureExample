//
//  AccountEditView.swift
//

import SwiftUI

struct AccountEditView<Presenter: PresenterForAccountEditView>: View {
    typealias Presenter = PresenterForAccountEditView

    @ObservedObject private var presenter: Presenter
    @State private var name: String = ""
    // TextFieldをdisableにする時に警告が表示される対策。先にフォーカスを外す
    @FocusState private var isTextFieldFocused: Bool

    init(presenter: Presenter) {
        self.name = presenter.name
        self.presenter = presenter
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField(Localized.loginAccountIdPlaceholder.key,
                          text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onChange(of: name) { value in
                    presenter.name = value
                }
                .onSubmit {
                    isTextFieldFocused = false
                    presenter.commit()
                }
                .focused($isTextFieldFocused)
                .disabled(presenter.isTextFieldDisabled)

                Button {
                    isTextFieldFocused = false
                    presenter.commit()
                } label: {
                    Text(Localized.accountEditSaveButtonTitle.key)
                }
                .disabled(presenter.isSaveButtonDisabled)
                .padding()

                Button {
                    isTextFieldFocused = false
                    presenter.cancel()
                } label: {
                    Text(Localized.accountEditCancelButtonTitle.key)
                }
                .padding()
            }
            .navigationTitle(Localized.accountEditTitle.key)
        }.navigationViewStyle(.stack)
    }
}

struct AccountEditView_Previews: PreviewProvider {
    private class PresenterStub: AccountEditView.Presenter {
        var name: String = "test-name"
        var isSaveButtonDisabled: Bool = false
        var isTextFieldDisabled: Bool = false

        func commit() {}
        func cancel() {}
    }

    static var previews: some View {
        AccountEditView(presenter: PresenterStub())
        .environment(\.locale, .init(identifier: "ja"))
    }
}
