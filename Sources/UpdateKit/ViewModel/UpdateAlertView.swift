//
//  UpdateAlertView.swift
//  UpdateKit
//
//  Created by Sharda Prasad on 05/07/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
public struct UpdateAlertView: View {
    @ObservedObject var manager: UpdateManager = .shared
    
    public init() {}
    
    public var body: some View {
        if manager.showUpdateAlert, let version = manager.latestVersion {
            VStack(spacing: 16) {
                Text("Update Available")
                    .font(.title).bold()
                Text("Version \(version) is available with improvements.")
                    .multilineTextAlignment(.center)
                
                HStack {
                    if !manager.isForceUpdate {
                        Button("Skip") {
                            manager.showUpdateAlert = false
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }

                    Button("Update Now") {
                        if let urlString = manager.appStoreURL,
                           let url = URL(string: urlString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding()
        }
    }
}

