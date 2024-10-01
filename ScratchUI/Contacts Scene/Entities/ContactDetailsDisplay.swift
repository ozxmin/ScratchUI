//
//  ContactDetailsDisplay.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 30/09/24.
//

import Foundation

// TODO: - create property wrapper for data fetching
// when annotating a property with the @DataFetcher it's initilized with a url. if its valid,
// the fetching will start and set the property as Result<Data, Error>


actor ContactDetailsDisplay {
    let exclusions = ["avatar", "id", "name", "lastName", "ethereumAddress"]

    let name: String
    let lastName: String
    let avatarURL: URL?
    var details: [(label: String, value: String)]
    var avatarData: Data?

    init(entity: ContactEntity) {
        name = entity.firstName
        lastName = entity.lastName
        avatarURL = URL(string: (entity.avatar ?? ""))
        let contactMirror = Mirror(reflecting: entity)
        let reflection = contactMirror.reflectionToStrings(excluding: exclusions)

        details = reflection.map { item in
            return (Self.format(label: item.label), item.value)
        }
    }

    private static func format(label: String) -> String {
        assert(!label.isEmpty, "label should not be empty")
        // Insert a space before every uppercase letter, except the first one
        let formatted = label.reduce("") { result, character in
            if character.isUppercase {
                return result + " " + String(character)
            }
            return result + String(character)
        }
        // Capitalize the first letter and lowercase the rest
        return formatted.prefix(1).capitalized + formatted.dropFirst()
    }
}

extension ContactDetailsDisplay {
    func fetchData(from url: URL) async -> Data? {
        do {
            let response = try? await URLSession.shared.data(for: URLRequest(url: url))
            if let data = response?.0 {
                return data
            }
            return nil
        }
    }
}



//
//@propertyWrapper
//class DataFetcher {
//    var wrappedValue: <#Value#>
//
//}
