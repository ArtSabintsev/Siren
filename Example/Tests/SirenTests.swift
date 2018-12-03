//
//  SirenTests.swift
//  SirenTests
//
//  Created by Arthur Sabintsev on 6/7/16.
//  Copyright © 2016 Sabintsev iOS Projects. All rights reserved.
//

import XCTest
@testable import Siren

final class SirenTests: XCTestCase {

    var siren: Siren = Siren.shared

}

// MARK: - Updates

extension SirenTests {

    func testSingleDigitVersionUpdate() {
        siren.currentInstalledVersion = "1"

        siren.currentAppStoreVersion = "2"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0.0.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.0.0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))
    }

    func testDoubleDigitVersionUpdate() {
        siren.currentInstalledVersion = "1.0"

        siren.currentAppStoreVersion = "2"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0.0.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.0.0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))
    }

    func testTripleDigitVersionUpdate() {
        siren.currentInstalledVersion = "1.0.0"

        siren.currentAppStoreVersion = "2"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0.0.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.0.0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))
    }

    func testQuadrupleDigitVersionUpdate() {
        siren.currentInstalledVersion = "1.0.0"

        siren.currentAppStoreVersion = "2"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "2.0.0.0"
        XCTAssertTrue(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                           appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))

        siren.currentAppStoreVersion = "0.0.0.9"
        XCTAssertFalse(VersionParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                            appStoreVersion: siren.currentAppStoreVersion))
    }
}

// MARK: - Localization

extension SirenTests {

    func testArabicLocalization() {
        let language: Localization.Language = .arabic

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "التحديث متوفر")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "المرة التالية")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "تخطى عن هذه النسخة")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "تحديث")
    }

    func testArmenianLocalization() {
        let language: Localization.Language = .armenian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Թարմացումը հասանելի Է")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Հաջորդ անգամ")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Բաց թողնել այս տարբերակը")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Թարմացնել")
    }

    func testBasqueLocalization() {
        let language: Localization.Language = .basque

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Eguneratzea erabilgarri")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Hurrengo batean")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Bertsio honetatik jauzi egin")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Eguneratu")
    }

    func testChineseSimplifiedLocalization() {
        let language: Localization.Language = .chineseSimplified

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "更新可用")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "下一次")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "跳过此版本")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "更新")
    }

    func testChineseTraditionalLocalization() {
        let language: Localization.Language = .chineseTraditional

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "有更新可用")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "下次")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "跳過此版本")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "更新")
    }

    func testCroatianLocalization() {
        let language: Localization.Language = .croatian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Nova ažuriranje je stigla")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Sljedeći put")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Preskoči ovu verziju")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Ažuriraj")
    }

    func testCzechLocalization() {
        let language: Localization.Language = .czech

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Aktualizace dostupná")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Příště")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Přeskočit tuto verzi")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Aktualizovat")
    }

    func testDanishLocalization() {
        let language: Localization.Language = .danish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Tilgængelig opdatering")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Næste gang")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Spring denne version over")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Opdater")
    }

    func testDutchLocalization() {
        let language: Localization.Language = .dutch

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Update beschikbaar")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Volgende keer")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Sla deze versie over")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Updaten")
    }

    func testEstonianLocalization() {
        let language: Localization.Language = .estonian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Uuendus saadaval")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Järgmisel korral")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Jäta see version vahele")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Uuenda")
    }

    func testFinnishLocalization() {
        let language: Localization.Language = .finnish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Päivitys saatavilla")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Ensi kerralla")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Jätä tämä versio väliin")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Päivitys")
    }

    func testFrenchLocalization() {
        let language: Localization.Language = .french

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Mise à jour disponible")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "La prochaine fois")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Sauter cette version")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Mettre à jour")
    }

    func testGermanLocalization() {
        let language: Localization.Language = .german

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Update erhältlich")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Später")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Diese Version überspringen")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Update")
    }
    
    func testGreekLocalization() {
        let language: Localization.Language = .greek

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Διαθέσιμη Ενημέρωση")
        
        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Άλλη φορά")
        
        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Αγνόησε αυτήν την έκδοση")
        
        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Αναβάθμιση")
    }

    func testHebrewLocalization() {
        let language: Localization.Language = .hebrew

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "עדכון זמין")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "בפעם הבאה")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "דלג על גרסה זו")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "עדכן")
    }

    func testHungarianLocalization() {
        let language: Localization.Language = .hungarian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Új frissítés érhető el")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Később")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Ennél a verziónál ne figyelmeztessen")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Frissítés")
    }

    func testIndonesianLocalization() {
        let language: Localization.Language = .indonesian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Pembaruan Tersedia")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Lain kali")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Lewati versi ini")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Perbarui")
    }

    func testItalianLocalization() {
        let language: Localization.Language = .italian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Aggiornamento disponibile")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "La prossima volta")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Salta questa versione")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Aggiorna")
    }

    func testJapaneseLocalization() {
        let language: Localization.Language = .japanese

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "アップデートのお知らせ")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "次回")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "このバージョンをスキップ")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "アップデート")
    }

    func testKoreanLocalization() {
        let language: Localization.Language = .korean

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "업데이트 가능")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "다음에")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "이 버전 건너뜀")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "업데이트")
    }

    func testLatvianLocalization() {
        let language: Localization.Language = .latvian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Atjauninājums pieejams")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Nākamreiz")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Izlaist šo versiju")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Atjaunināt")
    }

    func testLithuanianLocalization() {
        let language: Localization.Language = .lithuanian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Atnaujinimas")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Kitą kartą")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Praleisti šią versiją")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Atnaujinti")
    }

    func testMalayLocalization() {
        let language: Localization.Language = .malay

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Versi Terkini")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Lain kali")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Langkau versi ini")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Muat turun")
    }

    func testNorwegianLocalization() {
        let language: Localization.Language = .norwegian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Oppdatering tilgjengelig")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Neste gang")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Hopp over denne versjonen")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Oppdater")
    }

    func testPersianLocalization() {
        let language: Localization.Language = .persian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "بروزرسانی در دسترس")
        
        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "دفعه بعد")
        
        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "رد این نسخه")
        
        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "بروزرسانی")
    }
    
    func testPersianAfghanistanLocalization() {
        let language: Localization.Language = .persianAfghanistan
        
        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "بروزرسانی در دسترس")
        
        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "دگر بار")
        
        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "رد این نسخه")
        
        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "بروزرسانی")
    }
    
    func testPersianIranLocalization() {
        let language: Localization.Language = .persianIran

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "بروزرسانی در دسترس")
        
        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "دفعه بعد")
        
        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "رد این نسخه")
        
        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "بروزرسانی")
    }
    
    func testPolishLocalization() {
        let language: Localization.Language = .polish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Aktualizacja dostępna")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Następnym razem")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Pomiń wersję")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Zaktualizuj")
    }

    func testPortugueseBrazilLocalization() {
        let language: Localization.Language = .portugueseBrazil

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Atualização disponível")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Próxima vez")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Ignorar esta versão")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Atualizar")
    }

    func testPortuguesePortugalLocalization() {
        let language: Localization.Language = .portuguesePortugal

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Nova actualização disponível")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Próxima vez")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Ignorar esta versão")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Actualizar")
    }

    func testRussianLocalization() {
        let language: Localization.Language = .russian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Доступно обновление")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "В следующий раз")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Пропустить эту версию")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Обновить")
    }

    func testSerbianCyrillicLocalization() {
        let language: Localization.Language = .serbianCyrillic

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Ажурирање доступно")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Следећи пут")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Прескочи ову верзију")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Ажурирај")
    }

    func testSerbianLatinLocalization() {
        let language: Localization.Language = .serbianLatin

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Ažuriranje dostupno")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Sledeći put")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Preskoči ovu verziju")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Ažuriraj")
    }

    func testSlovenianLocalization() {
        let language: Localization.Language = .slovenian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Posodobitev aplikacije")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Naslednjič")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Ne želim")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Namesti")
    }

    func testSpanishLocalization() {
        let language: Localization.Language = .spanish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Actualización disponible")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "La próxima vez")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Saltar esta versión")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Actualizar")
    }

    func testSwedishLocalization() {
        let language: Localization.Language = .swedish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Tillgänglig uppdatering")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Nästa gång")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Hoppa över den här versionen")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Uppdatera")
    }

    func testThaiLocalization() {
        let language: Localization.Language = .thai

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "มีการอัพเดท")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "ไว้คราวหน้า")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "ข้ามเวอร์ชั่นนี้")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "อัพเดท")
    }

    func testTurkishLocalization() {
        let language: Localization.Language = .turkish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Güncelleme Mevcut")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Daha sonra")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Boşver")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Güncelle")
    }

    func testUkrainianLocalization() {
        let language: Localization.Language = .ukrainian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Доступне Оновлення")
        
        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Наступного разу")
        
        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Пропустити версію")
        
        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Оновити")
    }
    
    func testUrduLocalization() {
        let language: Localization.Language = .urdu

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "نیا اپڈیٹ")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "اگلی مرتبہ")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "اس ورزن کو چھوڑ دیں")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "اپڈیٹ کریں")
    }
    
    func testVietnameseLocalization() {
        let language: Localization.Language = .vietnamese

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLanguageLocalization: language), "Cập nhật mới")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLanguageLocalization: language), "Lần tới")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLanguageLocalization: language), "Bỏ qua phiên bản này")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLanguageLocalization: language), "Cập nhật")
    }
    
}
