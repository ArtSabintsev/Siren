//
//  Helpers.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Miscellaneous Helpers

extension Siren {
    func addObservers() {
        guard didBecomeActiveObserver == nil else { return }
        didBecomeActiveObserver = NotificationCenter
            .default
            .addObserver(forName: UIApplication.didBecomeActiveNotification,
                         object: nil,
                         queue: nil) { [weak self] _ in
                            guard let self = self else { return }
                            self.performVersionCheckRequest()
        }
    }

    func makeITunesURL(fromAPIManager apiManager: APIManager) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        var items: [URLQueryItem] = [URLQueryItem(name: "bundleId", value: Bundle.bundleID())]

        if let countryCode = apiManager.countryCode {
            let item = URLQueryItem(name: "country", value: countryCode)
            items.append(item)
        }

        components.queryItems = items

        guard let url = components.url, !url.absoluteString.isEmpty else {
            throw KnownError.malformedURL
        }

        return url
    }

    func isUpdateCompatibleWithDeviceOS(for model: LookupModel) -> Bool {
        guard let requiredOSVersion = model.results.first?.minimumOSVersion else {
            return false
        }

        let systemVersion = UIDevice.current.systemVersion

        guard systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedDescending ||
            systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedSame else {
                return false
        }

        return true
    }

    /// Routes a console-bound message to the `SirenLog` struct, which decorates the log message.
    ///
    /// - Parameter message: The message to decorate and log to the console.
    func printMessage(_ message: String) {
        if debugEnabled {
            Log(message)
        }
    }
}
