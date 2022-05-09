//
//  CurrentValue.swift
//

import Combine

/// プロパティの値をCurrentValueSubjectで保持するPropertyWrapper

@propertyWrapper class CurrentValue<Value> {
    init(wrappedValue: Value) {
        self.projectedValue = .init(wrappedValue)
    }

    var wrappedValue: Value {
        get { projectedValue.value }
        set { projectedValue.value = newValue }
    }

    let projectedValue: CurrentValueSubject<Value, Never>
}
