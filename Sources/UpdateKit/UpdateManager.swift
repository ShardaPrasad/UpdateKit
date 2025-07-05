//
//  UpdateManager.swift
//  UpdateKit
//
//  Created by Sharda Prasad on 05/07/25.
//

import Foundation
import Foundation
import SwiftUI

@available(iOS 13.0, *)
@MainActor
public final class UpdateManager: ObservableObject {
    
    public static let shared = UpdateManager()
    
    @Published public var showUpdateAlert = false
    @Published public var latestVersion: String?
    @Published public var appStoreURL: String?
    @Published public var isForceUpdate = false
    
    private let bundleID = Bundle.main.bundleIdentifier ?? ""
    private let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
    
    private init() {}
    
    private func isNewVersionAvailable(appStoreVersion: String) -> Bool {
        return appStoreVersion.compare(currentVersion, options: .numeric) == .orderedDescending
    }

    public func checkForUpdate(
        isForce: Bool = false,
        customURL: String? = nil,
        completion: ((Result<UpdateInfo, Error>) -> Void)? = nil
    ) {
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)") else {
            completion?(.failure(UpdateError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
                return
            }

            guard let data = data,
                  let response = try? JSONDecoder().decode(AppStoreResponse.self, from: data),
                  let appInfo = response.results.first else {
                DispatchQueue.main.async {
                    completion?(.failure(UpdateError.noAppInfo))
                }
                return
            }

            // Capture only the needed data — thread-safe
            let version = appInfo.version
            let trackURL = customURL ?? appInfo.trackViewUrl
            let releaseNotes = appInfo.releaseNotes ?? ""
            let updateType = UpdateManager.determineUpdateType(current: self.currentVersion, store: version)

            let updateInfo = UpdateInfo(
                version: version,
                currentVersion: self.currentVersion,
                releaseNotes: releaseNotes,
                trackViewUrl: trackURL,
                updateType: updateType,
                appMetadata: appInfo
            )

            DispatchQueue.main.async {
                if self.isNewVersionAvailable(appStoreVersion: version) {
                    self.latestVersion = version
                    self.appStoreURL = trackURL
                    self.isForceUpdate = isForce
                    self.showUpdateAlert = true
                    completion?(.success(updateInfo))
                    
                    DispatchQueue.main.async {
                        Task {
                            AlertPresenter.presentUpdateAlert(
                                version: version,
                                releaseNotes: releaseNotes,
                                isForce: isForce,
                                updateURL: trackURL
                            )
//                            await AlertPresenter.present(view:
//                                UpdateAlertView(
//                                    version: version,
//                                    releaseNotes: releaseNotes,
//                                    isForce: isForce,
//                                    onUpdate: {
//                                        if let url = URL(string: trackURL) {
//                                            UIApplication.shared.open(url)
//                                        }
//                                    },
//                                    onSkip: {
//                                        AlertPresenter.dismiss()
//                                    }
//                                )
//                            )
                        }
                    }
                } else {
                    completion?(.failure(UpdateError.noUpdateAvailable))
                }
            }

        }.resume()
    }

    /// Compares two version strings like "1.0.0" and "1.1.0"
    nonisolated static func determineUpdateType(current: String, store: String) -> UpdateType {
        let currentParts = current.split(separator: ".").compactMap { Int($0) }
        let storeParts = store.split(separator: ".").compactMap { Int($0) }

        guard !currentParts.isEmpty && !storeParts.isEmpty else {
            return .unknown
        }

        if storeParts[0] > currentParts[0] {
            return .major
        } else if storeParts.count > 1, storeParts[1] > currentParts[1] {
            return .minor
        } else if storeParts.count > 2, storeParts[2] > currentParts[2] {
            return .patch
        } else {
            return .revision
        }
    }
}

@available(iOS 13.0, *)
@MainActor
extension UpdateManager {
    
    public func checkForUpdate(completion: @escaping (Result<UpdateInfo, Error>) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)") else {
            return completion(.failure(UpdateError.invalidURL))
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self else { return }

            if let error { return DispatchQueue.main.async { completion(.failure(error)) } }

            guard
                let data,
                let appInfo = try? JSONDecoder().decode(AppStoreResponse.self, from: data).results.first
            else {
                return DispatchQueue.main.async { completion(.failure(UpdateError.noAppInfo)) }
            }

            let info = UpdateInfo(
                version: appInfo.version,
                currentVersion: self.currentVersion,
                releaseNotes: appInfo.releaseNotes,
                trackViewUrl: appInfo.trackViewUrl,
                updateType: UpdateManager.determineUpdateType(current: currentVersion, store: appInfo.version),
                appMetadata: appInfo
            )

            DispatchQueue.main.async { completion(.success(info)) }
        }.resume()
    }
}
