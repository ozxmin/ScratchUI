//
//  ContactDetailsDisplay.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 30/09/24.
//

import Foundation

// TODO: - create property wrapper for data fetching
// when annotating a property with the @DataFetcher it's init with a url. if its valid,
// the fetching will start and set the property as Result<Data, Error>

protocol InformationLevel {
    associatedtype Basic
}

enum Info: InformationLevel {
    enum Basic { }
    enum Grid { }
    enum Detailed { }
}


struct ContactDisplay<InfoLevel> {
    // TODO: - Inject exclusions in interactor
    let exclusions = ["avatar", "id", "name", "lastName", "ethereumAddress"]
    let name: String
    let lastName: String
    var details: [(label: String, value: String)]? //lazy.map?
    var avatarData: Data?

    private var avatarURL: URLComponents?

    init(_ entity: ContactEntity) {
        name = entity.firstName
        lastName = entity.lastName
        avatarURL = formatURLComponents(from: entity.avatar)

        if InfoLevel.self == Info.Detailed.self {
            details = propertiesToDisplayable(subject: entity)
        }
    }

    func getImageURL(size: Int? = nil) -> URL? {
        formatURLComponents(from: avatarURL?.string, imageSize: size)?.url
    }

    private func formatURLComponents(from string: String?, imageSize: Int? = nil) -> URLComponents? {
        guard let url = URL(string: string ?? "") else { return nil }
        var size = 20
        if InfoLevel.self == Info.Basic.self { size = 50 }
        if InfoLevel.self == Info.Detailed.self { size = 100 }
        if let imageSize { size = imageSize }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let sizeQuery = "size=\(size)x\(size)&set=set1"
        urlComponents?.query = sizeQuery
        return urlComponents
    }
}

// Displayable

extension ContactDisplay {
    private func propertiesToDisplayable<T>(subject: T) -> [(String, String)] {
        let contactMirror = Mirror(reflecting: subject)
        let reflection = contactMirror.reflectionToStrings(excluding: exclusions)

        let details = reflection.map { item in
            return (item.label.camelCaseToReadable(), item.value)
        }

        return details
    }


    private func fetchData(from url: URL) async -> Data? {
        do {
            let request = URLRequest(url: url)
            let response = try? await URLSession.shared.data(for: request)
            if let data = response?.0 {
                return data
            }
            return nil
        }
    }
}
