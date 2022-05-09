//
//  Assert.swift
//

func assertionFailureIfNotTest() {
    guard isNotTest else { return }
    assertionFailure()
}
