//
//  AccountEditView.swift
//

import SwiftUI

struct AccountEditView<Presenter: PresenterForAccountEditView>: View {
    @ObservedObject private var presenter: Presenter
    @State private var name: String = ""
    
    init(presenter: Presenter) {
        self.name = presenter.name
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField(Localized.loginAccountIdPlaceholder.key,
                          text: $name,
                          onCommit: { presenter.commit() })
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: name) { value in
                        presenter.name = value
                    }
                
                Button {
                    presenter.commit()
                } label: {
                    Text(Localized.accountEditSaveButtonTitle.key)
                }
                .disabled(presenter.isSaveButtonDisabled)
                .padding()
                
                Button {
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
    private class PresenterStub: PresenterForAccountEditView {
        var name: String = "test-name"
        var isSaveButtonDisabled: Bool = false
        
        func commit() {}
        func cancel() {}
    }
    
    static var previews: some View {
        AccountEditView(presenter: PresenterStub())
        .environment(\.locale, .init(identifier: "ja"))
    }
}
