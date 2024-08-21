//
//  NetworkClient.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/08/24.
//

import Foundation

struct Client {

    enum Sorting: String {
        case numberOfStars = "stars"
        case numberOfForks = "forks"
        case recency = "updated"
    }

    func findRepositories(matching query: String,
                          sortedBy sorting: Sorting) {
        var components = URLComponents()
        //URLQueryItem
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sorting.rawValue)
        ]

        // Getting a URL from our components is as simple as
        // accessing the 'url' property.
        let _ = components.url

    }
}
