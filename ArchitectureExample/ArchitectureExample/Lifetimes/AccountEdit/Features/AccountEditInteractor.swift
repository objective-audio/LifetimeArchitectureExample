//
//  AccountEditInteractor.swift
//

import Combine

/**
 アカウント編集画面の処理
 */

@MainActor
final class AccountEditInteractor {
    typealias AccountHolder = AccountHolderForAccountEditInteractor
    typealias RootModalLifecycle = RootModalLifecycleForAccountEditInteractor
    typealias AccountEditModalLifecycle = AccountEditModalLifecycleForAccountEditInteractor
    typealias ActionSender = ActionSenderForAccountEditInteractor

    private let lifetimeId: AccountEditLifetimeId

    private weak var accountHolder: AccountHolder?
    private weak var rootModalLifecycle: RootModalLifecycle?
    private weak var accountEditModalLifecycle: AccountEditModalLifecycle?
    private weak var actionSender: ActionSender?

    @CurrentValue var name: String
    @CurrentValue private(set) var isEdited: Bool = false
    @CurrentValue private(set) var canEdit: Bool = false

    private var cancellables: Set<AnyCancellable> = .init()

    init(lifetimeId: AccountEditLifetimeId,
         accountHolder: AccountHolder?,
         rootModalLifecycle: RootModalLifecycle?,
         accountEditModalLifecycle: AccountEditModalLifecycle?,
         actionSender: ActionSender?) {
        self.lifetimeId = lifetimeId
        self.accountHolder = accountHolder
        self.rootModalLifecycle = rootModalLifecycle
        self.accountEditModalLifecycle = accountEditModalLifecycle
        self.actionSender = actionSender
        self.name = accountHolder?.name ?? ""

        let originalName = self.accountHolder?.name
        self.$name
            .map { !$0.isEmpty && $0 != originalName }
            .removeDuplicates()
            .assign(to: \.value,
                    on: $isEdited)
            .store(in: &self.cancellables)

        accountEditModalLifecycle?.hasCurrentPublisher
            .map { !$0 }
            .assign(to: \.value,
                    on: self.$canEdit)
            .store(in: &self.cancellables)
    }

    func save() {
        guard self.isEdited else {
            return
        }

        self.accountHolder?.name = self.name
        self.finalize()
    }

    func cancel() {
        if self.isEdited {
            self.accountEditModalLifecycle?.addAlert(id: .destruct)
        } else {
            self.finalize()
        }
    }

    func logout() {
        self.finalize()

        // AccountEditの画面を閉じた後に上の階層でログアウト処理をする
        self.actionSender?.sendLogout(accountLifetimeId: self.lifetimeId.account)
        self.actionSender = nil
    }

    func finalize() {
        self.rootModalLifecycle?.removeAccountEdit(lifetimeId: self.lifetimeId)

        self.accountHolder = nil
        self.rootModalLifecycle = nil
        self.accountEditModalLifecycle = nil
        self.cancellables.removeAll()
    }
}
