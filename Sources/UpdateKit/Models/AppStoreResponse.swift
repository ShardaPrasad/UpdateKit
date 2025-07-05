//
//  AppStoreResponse.swift
//  UpdateKit
//
//  Created by Sharda Prasad on 05/07/25.
//

import Foundation

struct AppStoreResponse: Decodable {
    let resultCount: Int
    let results: [AppStoreApp]
}

public struct AppStoreApp: Decodable {
    let version: String
    let trackName: String
    let releaseNotes: String?
    let trackViewUrl: String
    let artworkUrl512: String?
    let primaryGenreName: String?
    let description: String?
    let currentVersionReleaseDate: String?
    let releaseDate: String?
    let minimumOsVersion: String?
    let formattedPrice: String?
    let sellerName: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: String?
    
    enum CodingKeys: String, CodingKey {
        case version
        case trackName
        case releaseNotes
        case trackViewUrl
        case artworkUrl512
        case primaryGenreName
        case description
        case currentVersionReleaseDate
        case releaseDate
        case minimumOsVersion
        case formattedPrice
        case sellerName
        case languageCodesISO2A
        case fileSizeBytes
    }
}

