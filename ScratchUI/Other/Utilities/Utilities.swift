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

        //move data formatting to datasource
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        let message = "Decoding failed from bundle, due to:"
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError(message + "\(file) '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            fatalError(message + "\(file),  \(type.self) type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError(message + "\(file)  missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON. \(context)")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}

extension String {
    func camelCaseToReadable() -> Self {
        assert(!self.isEmpty, "label should not be empty")

        let formatted = self.reduce("") { result, character in
            if character.isUppercase {
                return result + " " + String(character)
            }
            return result + String(character)
        }
        // Capitalize the first letter and lowercase the rest
        return formatted.prefix(1).capitalized + formatted.dropFirst()
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

func printQ(_ tag: Int) {
    // TODO: - change to checkQueue
    // if is not running on the main thread, launch warning
    if let queueLabel = String(validatingUTF8: __dispatch_queue_get_label(nil)) {
        log("\(tag) - Running on queue: \(queueLabel)")
    } else {
        log("Unknown queue")
    }
}

#if DEBUG
func log<T>(_ message: T) {
    print(message)
}
#endif

// TODO: - Convert to property wrapper. Takes self, and excluded. Returns array keyvaluepairs
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
