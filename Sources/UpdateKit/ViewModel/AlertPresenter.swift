//
//  AlertPresenter.swift
//  UpdateKit
//
//  Created by Sharda Prasad on 05/07/25.
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
@MainActor
public final class AlertPresenter {
    
    private static var presentedController: UIViewController?
    
    /// Presents a SwiftUI view as a fullscreen alert/modal.
    @MainActor
    static func present(view: some View) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let hosting = UIHostingController(rootView: view)
        hosting.view.backgroundColor = .clear
        hosting.modalPresentationStyle = .overFullScreen
        presentedController = hosting
        
        keyWindow.rootViewController?.present(hosting, animated: true, completion: nil)
    }
    
    
    /// Shows a UIKit alert for update
    public static func presentUpdateAlert(
        version: String,
        releaseNotes: String?,
        isForce: Bool,
        updateURL: String
    ) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        
        let message = "Version \(version) is available.\n\n\(releaseNotes ?? "")"
        let alert = UIAlertController(title: "🚀 New Update Available", message: message, preferredStyle: .alert)
        
        // Update Now button
        alert.addAction(UIAlertAction(title: "Update Now", style: .default, handler: { _ in
            if let url = URL(string: updateURL) {
                UIApplication.shared.open(url)
            }
        }))
        
        // Skip button (only if not forced)
        if !isForce {
            alert.addAction(UIAlertAction(title: "Skip", style: .cancel))
        }
        
        rootVC.present(alert, animated: true)
    }
    
    /// Dismisses the currently presented alert/modal.
    @MainActor
    static func dismiss() {
        presentedController?.dismiss(animated: true, completion: {
            presentedController = nil
        })
    }
}
