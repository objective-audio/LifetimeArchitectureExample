//
//  ModalConvertible.swift
//

protocol ModalConvertible {
    associatedtype ModalSource

    init?(_ source: ModalSource?)
}
