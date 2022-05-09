//
//  LoginNetwork.swift
//

import Foundation

enum LoginNetworkError: Error {
    case cancelled
    case invalidAccountID
}

final class LoginNetwork {
    func getAccount(id: String) async -> Result<Account, LoginNetworkError> {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                guard !Task.isCancelled else {
                    continuation.resume(returning: .failure(.cancelled))
                    return
                }
                
                guard let id = Int(id) else {
                    continuation.resume(returning: .failure(.invalidAccountID))
                    return
                }
                
                continuation.resume(returning: .success(.init(id: id, name: "account-\(id)")))
            }
        }
    }
}
