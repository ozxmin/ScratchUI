//
//  ContactDataManager.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import Foundation

class ContactDataManager {
    //TODO: - Get off main thread

    func mapToSections() -> Dictionary<String, [ContactEntity]> {
        let alphabet = CharacterSet.getAlphabet()!
        let array = decodeJsonData()

        let grouped = Dictionary(grouping: array) { String($0.name.first?.uppercased() ?? "#") }
        return grouped
    }

    func decodeJsonData() -> [ContactEntity] {
        let contacts: [ContactEntity] = Bundle.main.decode("contacts_mock_data")
        return contacts
    }
}

// MARK: - Utilities

extension CharacterSet {
    
    // stackoverflow.com/questions/69495317/how-to-get-localized-alphabet-swift-ios
    static func getAlphabet() -> [String]? {
        let local = Locale(identifier: Locale.current.identifier)
        let localSet = local.exemplarCharacterSet
        let upperCaseIntersection = localSet?.intersection(CharacterSet.uppercaseLetters)

        guard let charSubset = upperCaseIntersection else { return nil }
        
        let alphabet = charSubset.codePoints().compactMap { UnicodeScalar($0) }.map { String(Character($0)) }
        // If you don't sort alphabetical order is not guaranteed.
        let sorted = alphabet.sorted(by: {$0.localizedCompare($1) == .orderedAscending } )
        return sorted
    }

    private func codePoints() -> [Int] {
        var result: [Int] = []
        var plane = 0
        // following documentation at 
        // developer.apple.com/documentation/foundation/nscharacterset/1417719-bitmaprepresentation
        for (i, w) in bitmapRepresentation.enumerated() {
            let k = i % 0x2001
            if k == 0x2000 {
                // plane index byte
                plane = Int(w) << 13
                continue
            }
            let base = (plane + k) << 3
            for j in 0 ..< 8 where w & 1 << j != 0 {
                result.append(base + j)
            }
        }
        return result
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
}

