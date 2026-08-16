import XCTest
@testable import Siren

/// Smoke tests that the localization bundle is packaged and a few locales resolve.
/// Exhaustive string tables remain in Example/Tests/SirenTests.swift.
final class LocalizationTests: XCTestCase {

    func testEnglishFallsBackToKeyWhenNotForcedAwayFromDefault() {
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: .english),
                       "Update Available")
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: .english),
                       "Update")
    }

    func testForcedRussianLocalization() {
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: .russian),
                       "Доступно обновление")
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: .russian),
                       "Обновить")
    }

    func testForcedJapaneseLocalization() {
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: .japanese),
                       "アップデートのお知らせ")
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: .japanese),
                       "このバージョンをスキップ")
    }
}
