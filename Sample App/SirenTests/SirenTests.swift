//
//  SirenTests.swift
//  SirenTests
//
//  Created by Arthur Sabintsev on 6/7/16.
//  Copyright © 2016 Sabintsev iOS Projects. All rights reserved.
//

import XCTest
@testable import Siren

class SirenTests: XCTestCase {

    func testArabicLocalization() {
        let language: SirenLanguageType = .Arabic
        Siren.sharedInstance.forceLanguageLocalization = language

        // Update Available"
        XCTAssertEqual(NSBundle().localizedString("Update Available", forceLanguageLocalization: language), "التجديد متوفر")

        // Next time
        XCTAssertEqual(Siren.sharedInstance.localizedNextTimeButtonTitle(), "المرة التالية")

        // Skip this version
        XCTAssertEqual(Siren.sharedInstance.localizedSkipButtonTitle(), "تخطى عن هذه النسخة")

        // Update
        XCTAssertEqual(Siren.sharedInstance.localizedUpdateButtonTitle(), "تجديد")
    }

    func testArmenianLocalization() {
        let language: SirenLanguageType = .Armenian
        Siren.sharedInstance.forceLanguageLocalization = language

        // Update Available"
        XCTAssertEqual(NSBundle().localizedString("Update Available", forceLanguageLocalization: language), "Թարմացումը հասանելի Է")

        // Next time
        XCTAssertEqual(Siren.sharedInstance.localizedNextTimeButtonTitle(), "Հաջորդ անգամ")

        // Skip this version
        XCTAssertEqual(Siren.sharedInstance.localizedSkipButtonTitle(), "Բաց թողնել այս տարբերակը")

        // Update
        XCTAssertEqual(Siren.sharedInstance.localizedUpdateButtonTitle(), "Թարմացնել")
    }

    func testDanishLocalization() {
        let language: SirenLanguageType = .Danish
        Siren.sharedInstance.forceLanguageLocalization = language

        // Update Available"
        XCTAssertEqual(NSBundle().localizedString("Update Available", forceLanguageLocalization: language), "Tilgængelig opdatering")

        // Next time
        XCTAssertEqual(Siren.sharedInstance.localizedNextTimeButtonTitle(), "Næste gang")

        // Skip this version
        XCTAssertEqual(Siren.sharedInstance.localizedSkipButtonTitle(), "Spring denne version over")

        // Update
        XCTAssertEqual(Siren.sharedInstance.localizedUpdateButtonTitle(), "Opdater")
    }

    func testGermanLocalization() {
        let language: SirenLanguageType = .German
        Siren.sharedInstance.forceLanguageLocalization = language

        // Update Available"
        XCTAssertEqual(NSBundle().localizedString("Update Available", forceLanguageLocalization: language), "Update erhältlich")

        // Next time
        XCTAssertEqual(Siren.sharedInstance.localizedNextTimeButtonTitle(), "Später")

        // Skip this version
        XCTAssertEqual(Siren.sharedInstance.localizedSkipButtonTitle(), "Diese Version überspringen")

        // Update
        XCTAssertEqual(Siren.sharedInstance.localizedUpdateButtonTitle(), "Update")
    }

}
