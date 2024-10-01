//
//  ContactEntity.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 30/09/24.
//
import Swift

struct ContactEntity: Identifiable, Codable, Hashable {
    let id: Int
    let firstName: String
    let lastName: String
    let phone: String
    let avatar: String?
    let address: String
    let email: String
    let dateAdded: String
    let gender: String
    let ethereumAddress: String?
    let companyName: String?
    let country: String?
    let normalDistVal: Double?
}
