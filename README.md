UpdateKit 🚀

UpdateKit is a lightweight Swift package for iOS apps that checks for App Store updates and presents update alerts — supporting force updates, optional updates, and fully customizable UI.

🧹 Features

🔍 Detects latest App Store version

❌ Supports both optional and force update modes

🖼️ Customizable alerts (SwiftUI + UIKit)

🧐 Auto-classifies version changes as:

.major, .minor, .patch, .revision

📱 iOS 13+ compatible

🧪 Completion handler or async support for manual control

🛠 Usage

✅ 1. Force or Optional Update With Alert (UI auto-shown)

Use this when you want UpdateKit to handle the UI for you:

    UpdateManager.shared.checkForUpdate(isForce: false)

isForce: true → Force update alert (user must update, no skip)

isForce: false → Optional update alert (user can skip)

ℹ️ Internally uses AlertPresenter to display a native modal.

✅ 2. Programmatic Update Check (Manual handling)

Use this when you want to control update behavior yourself (e.g. show a custom alert, only trigger for .major updates, etc.):


    UpdateManager.shared.checkForUpdate { result in
    switch result {
    case .success(let info):
    
        print("✅ Update available:", info.version)
        print("📜 Release Notes:", info.releaseNotes)
        print("🔗 App Store Link:", info.trackViewUrl)
        // Optional: present your own custom popup
        // Example: AlertPresenter.presentCustomAlert(for: info)

    case .failure(let error):
        print("❌ No update or failed to check:", error.localizedDescription)
    }
}

Use this when:

You want full UI control

You need update type info (.major, .minor, etc.)

You want to log analytics or show a branded popup

📆 Installation

➕ Swift Package Manager

Via Xcode

In Xcode, go to File > Add Packages

Enter the package URL:

https://github.com/ShardaPrasad/UpdateKit

Choose the latest version and add to your app target.

Or via Package.swift

.package(url: "https://github.com/ShardaPrasad/UpdateKit.git", from: "1.0.0")

Then add "UpdateKit" to your target dependencies.

![Optional](https://github.com/ShardaPrasad/Files/blob/main/Screenshots/1.png))
![Force](https://github.com/ShardaPrasad/Files/blob/main/Screenshots/2.png)

Optional Update Alert

Force Update Alert

Custom Alert with Notes

📄 License

This project is licensed under the MIT License.
