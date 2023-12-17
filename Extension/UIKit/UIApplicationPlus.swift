import UIKit

extension UIApplication {
    
    struct Release {
        let version: String
        var notes: String?
        init?(version: String?, notes: String?) {
            guard let version else { return nil }
            self.version = version
            self.notes = notes
        }
        
        var needsUpdate: Bool {
            guard let appVersion = Bundle.main.version else { return false }
            return appVersion.compare(version, options: .numeric) == .orderedAscending
        }
    }
    
    static func getLatestRelease(completed: @escaping (Release?) -> Void) {
        
        func didGetNewRelease(_ release: Release?) {
            DispatchQueue.main.async {
                if release.isVoid && isTesterDebugging {
                    let release = Release(version: Bundle.main.version.orEmpty + ".1", notes: nil)
                    completed(release)
                    return
                }
                completed(release)
            }
        }
        let getAppVersion = DispatchWorkItem {
            guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(String.appID)") else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let response = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
                    didGetNewRelease(nil)
                    return
                }
                guard let results = response["results"] as? [[String: Any]], let info = results.first else {
                    didGetNewRelease(nil)
                    return
                }
                let version = info["version"] as? String
                let notes = info["releaseNotes"] as? String
                let release = Release(version: version, notes: notes)
                didGetNewRelease(release)
            } catch {
                completed(nil)
            }
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: getAppVersion)
    }
    
    static func openSettings() {
        guard let settingsURL = URL(string: openSettingsURLString) else { return }
        openURL(settingsURL)
    }
    
    static func openURL(_ urlToOpen: URL,
                        options: [OpenExternalURLOptionsKey : Any] = [:],
                        completionHandler: ((Bool) -> Void)? = nil) {
        guard shared.canOpenURL(urlToOpen) else {
            assertionFailure("Can't open the given URL. Check and re-check.")
            return
        }
        if #available(iOS 10, *) {
            shared.open(urlToOpen, options: options, completionHandler: completionHandler)
        } else {
            shared.openURL(urlToOpen)
        }
    }
}
