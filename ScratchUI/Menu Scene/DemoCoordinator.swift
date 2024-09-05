//
//  DemoCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/09/24.
//

import UIKit

struct DemoInfo: Hashable, RawRepresentable, ExpressibleByStringLiteral {
    var rawValue: RawValue {
        screen
    }
    typealias RawValue = UIViewController.Type

    let name: String
    let screen: RawValue

    init(stringLiteral: StringLiteralType) {
        name = String(stringLiteral)
        switch stringLiteral {
            case "ContactTableViewController": screen = ContactsTableViewController.self
            default: screen = ContactDetailViewController.self
        }
    }

    init?(rawValue: RawValue) {
        screen = rawValue
        name = String(describing: rawValue)
    }

    static func == (lhs: DemoInfo, rhs: DemoInfo) -> Bool {
        lhs.screen.self == rhs.screen.self
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: screen))
    }
}

enum Demos: DemoInfo, CaseIterable {
    case contacts
    case test
    //case three = DemoInfo(rawValue: ContactTableViewController.self)
    //case dream = ContactTableViewController.self
    var rawValue: DemoInfo {
        switch self {
            case .contacts: return DemoInfo(rawValue: ContactsTableViewController.self)!
            case .test: return DemoInfo(rawValue: ContactDetailViewController.self)!
        }
    }

    init?(rawValue: DemoInfo) {
        switch rawValue.screen {
            case is ContactsTableViewController.Type: self = .contacts
            case is ContactDetailViewController.Type: self = .test
            default: return nil
        }
    }

    static subscript(index: Int) -> Demos? {
        guard index >= 0 && index < Self.allCases.count else {
            return nil
        }
        return Self.allCases[index]
    }

    func index() -> Int? {
        return Self.allCases.firstIndex(of: self)
    }
}
