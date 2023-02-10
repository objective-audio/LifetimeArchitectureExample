//
//  InstanceId.swift
//

final class InstanceId {}

extension InstanceId: Hashable {
    static func == (lhs: InstanceId, rhs: InstanceId) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
