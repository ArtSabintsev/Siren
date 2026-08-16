import XCTest
@testable import Siren

final class DataParserTests: XCTestCase {

    // MARK: - isAppStoreVersionNewer

    func testSingleDigitVersionUpdate() {
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1", appStoreVersion: "2"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1", appStoreVersion: "2.0"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1", appStoreVersion: "2.0.0"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1", appStoreVersion: "2.0.0.0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1", appStoreVersion: "0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1", appStoreVersion: "0.9"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1", appStoreVersion: "0.0.9"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1", appStoreVersion: "0.0.0.9"))
    }

    func testDoubleDigitVersionUpdate() {
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "2"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "2.0"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "2.0.0"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "2.0.0.0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "0.9"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "0.0.9"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "0.0.0.9"))
    }

    func testTripleDigitVersionUpdate() {
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0", appStoreVersion: "2"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0", appStoreVersion: "2.0"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0", appStoreVersion: "2.0.0"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0", appStoreVersion: "2.0.0.0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0", appStoreVersion: "0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0", appStoreVersion: "0.9"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0", appStoreVersion: "0.0.9"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0", appStoreVersion: "0.0.0.9"))
    }

    func testQuadrupleDigitVersionUpdate() {
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.0", appStoreVersion: "2"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.0", appStoreVersion: "2.0"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.0", appStoreVersion: "2.0.0"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.0", appStoreVersion: "2.0.0.0"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.0", appStoreVersion: "1.0.0.1"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.0", appStoreVersion: "0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.0", appStoreVersion: "0.9"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.0", appStoreVersion: "0.0.9"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.0", appStoreVersion: "0.0.0.9"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0.1", appStoreVersion: "1.0.0.0"))
    }

    func testUnequalLengthVersionsAreEqualWhenMissingComponentsAreZero() {
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "1.0.0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0.0", appStoreVersion: "1.0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: "1.0.0.0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "2.3", appStoreVersion: "2.3.0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "2.3.0", appStoreVersion: "2.3"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "2", appStoreVersion: "2.0.1"))
        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: "2.3", appStoreVersion: "2.3.1"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "2.3.1", appStoreVersion: "2.3"))
    }

    func testNilVersionsAreNotNewer() {
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: nil, appStoreVersion: "1.0"))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: "1.0", appStoreVersion: nil))
        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: nil, appStoreVersion: nil))
    }

    // MARK: - parseForUpdate

    func testParseForUpdateMajorMinorPatchRevision() {
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "1.0.0.0", andAppStoreVersion: "2.0.0.0"), .major)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "1.0.0.0", andAppStoreVersion: "1.1.0.0"), .minor)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "1.0.0.0", andAppStoreVersion: "1.0.1.0"), .patch)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "1.0.0.0", andAppStoreVersion: "1.0.0.1"), .revision)
    }

    func testParseForUpdateZeroPadsShorterInstalledVersion() {
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "2", andAppStoreVersion: "2.0.1"), .patch)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "2.3", andAppStoreVersion: "2.3.1"), .patch)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "1.0", andAppStoreVersion: "2.0"), .major)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "1.0", andAppStoreVersion: "1.1"), .minor)
    }

    func testParseForUpdateUnknownWhenEqualOrOlderOrNil() {
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "1.0.0", andAppStoreVersion: "1.0"), .unknown)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "1.0.0", andAppStoreVersion: "1.0.0"), .unknown)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "2.0.0", andAppStoreVersion: "1.9.9"), .unknown)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: nil, andAppStoreVersion: "1.0"), .unknown)
        XCTAssertEqual(DataParser.parseForUpdate(forInstalledVersion: "1.0", andAppStoreVersion: nil), .unknown)
    }

    // MARK: - RulesManager

    func testLoadRulesForUpdateType() throws {
        let rules = RulesManager(
            majorUpdateRules: .critical,
            minorUpdateRules: .annoying,
            patchUpdateRules: .default,
            revisionUpdateRules: .relaxed
        )
        XCTAssertEqual(try rules.loadRulesForUpdateType(.major).alertType, .force)
        XCTAssertEqual(try rules.loadRulesForUpdateType(.minor).alertType, .option)
        XCTAssertEqual(try rules.loadRulesForUpdateType(.patch).alertType, .skip)
        XCTAssertEqual(try rules.loadRulesForUpdateType(.revision).alertType, .skip)
        XCTAssertThrowsError(try rules.loadRulesForUpdateType(.unknown)) { error in
            guard case KnownError.noUpdateAvailable = error else {
                return XCTFail("Expected KnownError.noUpdateAvailable, got \(error)")
            }
        }
    }
}
