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

struct AppStoreApp: Decodable {
    let version: String
    let trackViewUrl: String
    let releaseNotes: String?
    let currentVersionReleaseDate: String?
}
