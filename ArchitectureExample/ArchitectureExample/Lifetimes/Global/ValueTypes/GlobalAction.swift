//
//  GlobalAction.swift
//

/**
 Lifetimeのヒエラルキー全体に対して送信する値
 */

struct GlobalAction {
    let kind: GlobalActionKind
    let id: GlobalActionId?
}
