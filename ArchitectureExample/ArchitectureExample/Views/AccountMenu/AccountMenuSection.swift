//
//  AccountMenuSection.swift
//

struct AccountMenuSection: Hashable {
    enum Kind {
        case info
        case logout
    }
    
    let kind: Kind
    let contents: [AccountMenuContent]
}
