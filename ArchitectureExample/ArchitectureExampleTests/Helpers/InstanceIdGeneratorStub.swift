//
//  InstanceIdGeneratorStub.swift
//

@testable import ArchitectureExample

class InstanceIdGeneratorStub: InstanceIdGeneratable {
    private(set) var genarated: [InstanceId] = []

    func generate() -> InstanceId {
        let id = InstanceId()
        self.genarated.append(id)
        return id
    }
}
