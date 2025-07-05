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
    
    public func checkForUpdate(isForce: Bool) {
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            guard error == nil,
                  let data = data,
                  let response = try? JSONDecoder().decode(AppStoreResponse.self, from: data),
                  let appInfo = response.results.first else { return }

            DispatchQueue.main.async {
                self.latestVersion = appInfo.version
                self.appStoreURL = appInfo.trackViewUrl
                self.isForceUpdate = isForce
                if appInfo.version.compare(self.currentVersion, options: .numeric) == .orderedDescending {
                    self.showUpdateAlert = true
                }
            }
        }.resume()
    }
}


