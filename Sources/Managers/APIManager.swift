//
//  APIManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 11/24/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// APIManager for Siren
public struct APIManager {
    /// Return results or errors obtained from performing a version check with Siren.
    typealias CompletionHandler = (LookupModel?, KnownError?) -> Void

    /// The region or country of an App Store in which the app is available.
    /// By default, all version check requests are performed against the US App Store.
    /// If the app is not available in the US App Store, set it to the identifier of at least one App Store region within which it is available.
    ///
    /// [List of country codes](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html)
    ///
    let countryCode: String?

    /// Initializes `APIManager` to the region or country of an App Store in which the app is available.
    /// By default, all version check requests are performed against the US App Store.
    /// If the app is not available in the US App Store, set it to the identifier of at least one App Store region within which it is available.
    ///
    /// [List of country codes](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html)
    ///
    /// - Parameter countryCode: The country code for the App Store in which the app is availabe. Defaults to nil (e.g., the US App Store)
    public init(countryCode: String? = nil) {
        self.countryCode = countryCode
    }

    /// The default `APIManager`.
    ///
    /// The version check is performed against the  US App Store.
    public static let `default` = APIManager()
}

extension APIManager {
    func performVersionCheckRequest(completion handler: CompletionHandler?) {
        guard Bundle.main.bundleIdentifier != nil else {
            handler?(nil, .missingBundleID)
            return
        }

        do {
            let url = try makeITunesURL()
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                URLCache.shared.removeCachedResponse(for: request)
                self.processVersionCheckResults(withData: data, response: response, error: error, completion: handler)
            }.resume()
        } catch {
            handler?(nil, .malformedURL)
        }
    }

    private func processVersionCheckResults(withData data: Data?,
                                            response: URLResponse?,
                                            error: Error?,
                                            completion handler: CompletionHandler?) {
        if let error = error {
            handler?(nil, .appStoreDataRetrievalFailure(underlyingError: error))
        } else {
            guard let data = data else {
                handler?(nil, .appStoreDataRetrievalFailure(underlyingError: nil))
                return
            }
            do {
                let lookupModel = try JSONDecoder().decode(LookupModel.self, from: data)

                guard !lookupModel.results.isEmpty else {
                    handler?(nil, .appStoreDataRetrievalEmptyResults)
                    return
                }

                DispatchQueue.main.async {
                    handler?(lookupModel, nil)
                }
            } catch {
                handler?(nil, .appStoreJSONParsingFailure(underlyingError: error))
            }
        }
    }

    private func makeITunesURL() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        var items: [URLQueryItem] = [URLQueryItem(name: "bundleId", value: Bundle.main.bundleIdentifier)]

        if let countryCode = countryCode {
            let item = URLQueryItem(name: "country", value: countryCode)
            items.append(item)
        }

        components.queryItems = items

        guard let url = components.url, !url.absoluteString.isEmpty else {
            throw KnownError.malformedURL
        }

        return url
    }
}
