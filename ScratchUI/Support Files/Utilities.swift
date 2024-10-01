//
//  Utilities.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 10/09/24.
//

import Foundation

// MARK: - Utilities


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

        decoder.keyDecodingStrategy = .convertFromSnakeCase
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

extension CharacterSet {
    // stackoverflow.com/questions/69495317/how-to-get-localized-alphabet-swift-ios
    /// gets all the letters in a locale's alphabet
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


func log(_ message: String) {
#if DEBUG
    print(message)
#endif

}

// TODO: - Convert to property wrapper. Takes self, and excluded. Returs array keyvaluepairs
extension Mirror {
    func reflectionToStrings(excluding excluded: [String]) -> [(label: String, value: String)] {
        let childToString = { (child: Child) -> (String, String)? in
            guard let label = child.label,
                  let value = child.value as? String? else {
                return nil
            }
            if excluded.contains(label) { return nil }
            return (label, (value ?? "---"))
        }

        let labelValue = children.compactMap(childToString)
        return labelValue
    }
}
