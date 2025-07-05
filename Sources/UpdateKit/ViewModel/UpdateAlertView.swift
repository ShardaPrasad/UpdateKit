//
//  UpdateAlertView.swift
//  UpdateKit
//
//  Created by Sharda Prasad on 05/07/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct UpdateAlertView: View {
    let version: String
    let currentVersion: String
    let releaseNotes: String
    let isForce: Bool
    let onUpdate: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("🚀 New Update Available")
                .font(.title)
                .bold()

            Text("Version \(version)\n\n\(releaseNotes)")
                .font(.body)
                .multilineTextAlignment(.center)

            HStack {
                if !isForce {
                    Button("Later") {
                        onSkip()
                    }
                    .padding()
                }

                Button("Update Now") {
                    onUpdate()
                }
                .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .padding(30)
    }
}

@available(iOS 13.0, *)
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
