//
//  UpdateInfo.swift
//  UpdateKit
//
//  Created by Sharda Prasad on 05/07/25.
//

public struct UpdateInfo {
    public let version: String
    public let currentVersion: String
    public let releaseNotes: String?
    public let trackViewUrl: String
    public let updateType: UpdateType
    public let appMetadata: AppStoreApp
}

public enum UpdateType: String {
    case major
    case minor
    case patch
    case revision
    case unknown
}

