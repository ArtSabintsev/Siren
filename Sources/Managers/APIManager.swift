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
    /// Constants used in the `APIManager`.
    private struct Constants {
        /// Constant for the `bundleId` parameter in the iTunes Lookup API request.
        static let bundleID = "bundleId"
        /// Constant for the `country` parameter in the iTunes Lookup API request.
        static let country = "country"
        /// Constant for the `lang` parameter in the iTunes Lookup API request.
        static let language = "lang"
        /// Constant for the `entity` parameter in the iTunes Lookup API reqeust.
        static let entity = "entity"
        /// Constant for the `entity` parameter value when performing a tvOS iTunes Lookup API reqeust.
        static let tvSoftware = "tvSoftware"
    }

    /// Return results or errors obtained from performing a version check with Siren.
    typealias CompletionHandler = (Result<APIModel, KnownError>) -> Void

    /// The Bundle ID for the your application. Defaults to "Bundle.main.bundleIdentifier".
    let bundleID: String?
    
    /// The region or country of an App Store in which the app is available.
    let country: AppStoreCountry
    
    /// The language for the localization of App Store responses.
    let language: String?

    /// Initializes `APIManager` to the region or country of an App Store in which the app is available.
    /// By default, all version check requests are performed against the US App Store and the language of the copy/text is returned in English.
    /// - Parameters:
    ///  - country: The country for the App Store in which the app is available.
    ///  - language: The locale to use for the App Store notes. The default result the API returns is equivalent to passing "en_us", so passing `nil` is equivalent to passing "en_us".
    ///  - bundleID: The bundleID for your app. Defaults to `Bundle.main.bundleIdentifier`. Passing `nil` will throw a `missingBundleID` error.
    public init(country: AppStoreCountry = .unitedStates, language: String? = nil, bundleID: String? = Bundle.main.bundleIdentifier) {
      self.country = country
      self.language = language
      self.bundleID = bundleID
    }

    /// The default `APIManager`.
    ///
    /// The version check is performed against the  US App Store.
    public static let `default` = APIManager()
}

extension APIManager {
    /// Convenience initializer that initializes `APIManager` to the region or country of an App Store in which the app is available.
    /// If nil, version check requests are performed against the US App Store.
    ///
    /// - Parameter countryCode: The raw country code for the App Store in which the app is available.
    public init(countryCode: String?) {
      self.init(country: .init(code: countryCode))
    }

    /// Creates and performs a URLRequest against the iTunes Lookup API.
    ///
    /// - returns APIModel: The decoded JSON as an instance of APIModel.
    func performVersionCheckRequest() async throws -> APIModel {
        guard bundleID != nil else {
            throw KnownError.missingBundleID
        }

        do {
            let url = try makeITunesURL()
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            let (data, response) = try await URLSession.shared.data(for: request)
            return try processVersionCheckResults(withData: data, response: response)
        } catch {
            throw error
        }
    }

    /// Parses and maps the the results from the iTunes Lookup API request.
    ///
    /// - Parameters:
    ///   - data: The JSON data returned from the request.
    ///   - response: The response metadata returned from the request.
    private func processVersionCheckResults(withData data: Data?, response: URLResponse?) throws -> APIModel {
        guard let data = data else {
            throw KnownError.appStoreDataRetrievalFailure(underlyingError: nil)
        }
        do {
            let apiModel = try JSONDecoder().decode(APIModel.self, from: data)

            guard !apiModel.results.isEmpty else {
                throw KnownError.appStoreDataRetrievalEmptyResults
            }

            return apiModel
        } catch {
            throw KnownError.appStoreJSONParsingFailure(underlyingError: error)
        }
    }

    /// Creates the URL that points to the iTunes Lookup API.
    ///
    /// - Returns: The iTunes Lookup API URL.
    /// - Throws: An error if the URL cannot be created.
    private func makeITunesURL() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        var items: [URLQueryItem] = [URLQueryItem(name: Constants.bundleID, value: bundleID)]

        #if os(tvOS)
        let tvOSQueryItem = URLQueryItem(name: Constants.entity, value: Constants.tvSoftware)
        items.append(tvOSQueryItem)
        #endif

        if let countryCode = country.code {
            let item = URLQueryItem(name: Constants.country, value: countryCode)
            items.append(item)
        }
        
        if let language = language {
            let item = URLQueryItem(name: Constants.language, value: language)
            items.append(item)
        }

        components.queryItems = items

        guard let url = components.url, !url.absoluteString.isEmpty else {
            throw KnownError.malformedURL
        }

        return url
    }
}
