//
//  InstanceIdGenerator.swift
//

@testable import ArchitectureExample

class InstanceIdGenerator {
    private(set) var genarated: [InstanceId] = []

    func generate() -> InstanceId {
        let id = InstanceId()
        self.genarated.append(id)
        return id
    }
}
