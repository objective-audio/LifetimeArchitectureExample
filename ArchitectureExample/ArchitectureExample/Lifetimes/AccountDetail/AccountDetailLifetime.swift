//
//  AccountDetailLifetime.swift
//

import Foundation

/**
 アカウント詳細画面の生存期間で必要な機能を保持する
 */

struct AccountDetailLifetime {
    let lifetimeId: AccountDetailLifetimeId
    let interactor: AccountDetailInteractor
}
