//
//  AccountMenuSection.swift
//

struct AccountMenuSection {
    enum Kind {
        case info
        case logout
    }

    let kind: Kind
    let contents: [AccountMenuContent]
}
