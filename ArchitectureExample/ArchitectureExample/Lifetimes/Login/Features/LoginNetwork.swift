//
//  LoginNetwork.swift
//

import Foundation

enum LoginNetworkError: Error {
    case cancelled
    case invalidAccountID
}

/**
 ログインの通信処理（を模したもの）
 */

final class LoginNetwork {
    func getAccount(id: String,
                    completion: @escaping (Result<Account, LoginNetworkError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            guard !Task.isCancelled else {
                completion(.failure(.cancelled))
                return
            }

            guard let id = Int(id) else {
                completion(.failure(.invalidAccountID))
                return
            }

            completion(.success(.init(id: id, name: "account-name-\(id)")))
        }
    }

    func getAccount(id: String) async -> Result<Account, LoginNetworkError> {
        await withCheckedContinuation { continuation in
            self.getAccount(id: id) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
