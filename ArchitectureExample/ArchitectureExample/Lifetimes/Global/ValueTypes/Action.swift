//
//  Action.swift
//

/**
 Lifetimeのヒエラルキー全体に対して送信する値
 */

struct Action {
    let kind: ActionKind
    let id: ActionId?
}
