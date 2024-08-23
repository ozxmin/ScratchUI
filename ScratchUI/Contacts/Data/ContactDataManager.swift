//
//  ContactDataManager.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import Foundation

class ContactDataManager {
    //TODO: - Get off main thread
    func getData() -> [ContactEntity] {
        let contacts: [ContactEntity] = Bundle.main.decode("contacts_mock_data")
        return contacts

    }
}

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: "json") else {
            fatalError("!!!Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("!!Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        let formatter = DateFormatter()

        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            fatalError("Failed to decode \(file), type: \(type.self) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON. \(context)")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }

}


struct ContactEntity: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let lastName: String
    let phone: String
    let avatar: String
    let address: String
    let email: String
    let dateAdded: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "first_name"
        case lastName = "last_name"
        case phone
        case avatar
        case address
        case email
        case dateAdded = "date_added"
    }
    //{"id":4,"first_name":"Phebe","last_name":"Plues","email":"pplues3@hc360.com","phone":"523-613-1844","address":"61 Blaine Road","normal_dist_val":0.56,"date_added":"5/15/2024","avatar":"https://robohash.org/accusantiumetquis.jpg?size=50x50&set=set1"}
}

