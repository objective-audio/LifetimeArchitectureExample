//
//  InstanceId.swift
//

class InstanceId {
}

extension InstanceId: Equatable {
    static func == (lhs: InstanceId, rhs: InstanceId) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
