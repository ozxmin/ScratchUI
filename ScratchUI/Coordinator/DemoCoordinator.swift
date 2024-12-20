//
//  DemoCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/09/24.
//

import UIKit

enum Either<T, U> {
    case this(T)
    case that(U)
}

// TODO: - Use reflection to make it easier to add new scene cases.
// -
// Desired output: Just add a case to have everything working
// i.e.: Add a case, raw type is an a repository instance. The raw-type is the title.
// the mirror fills in the repo computed variable

@dynamicMemberLookup
enum Coordinator: String, CaseIterable {
    case contacts = "Contacts"
    case details = "Details"
    case collection = "Collection"
}

/// - Helpers
extension Coordinator {
    subscript<T>(dynamicMember member: KeyPath<Repository, T>) -> T {
        repo[keyPath: member]
    }

    static subscript(index: Int) -> Coordinator? {
        guard index >= 0 && index < allCases.count else {
            return nil
        }
        return allCases[index]
    }

    var index: Int? {
        Self.allCases.firstIndex(of: self)
    }
}



protocol Injectable {
    init<D>(dependencies: D)
}
