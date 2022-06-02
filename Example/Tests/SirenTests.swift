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

// MARK: - API

extension SirenTests {
  func testAPIDefaultsToUnitedStatesAppStore() {
    XCTAssertEqual(siren.apiManager.country, AppStoreCountry.unitedStates)
  }
}

// MARK: - Updates

extension SirenTests {

    func testSingleDigitVersionUpdate() {
        siren.currentInstalledVersion = "1"

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0.0"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0.0.0"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "0"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "0.9"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "0.0.9"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "0.0.0.9"))
    }

    func testDoubleDigitVersionUpdate() {
        siren.currentInstalledVersion = "1.0"

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0.0"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0.0.0"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0.9"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0.0.9"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0.0.0.9"))
    }

    func testTripleDigitVersionUpdate() {
        siren.currentInstalledVersion = "1.0.0"

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0.0"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0.0.0"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0.9"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0.0.9"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0.0.0.9"))
    }

    func testQuadrupleDigitVersionUpdate() {
        siren.currentInstalledVersion = "1.0.0"

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0.0"))

        XCTAssertTrue(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                        appStoreVersion: "2.0.0.0"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0.9"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0.0.9"))

        XCTAssertFalse(DataParser.isAppStoreVersionNewer(installedVersion: siren.currentInstalledVersion,
                                                         appStoreVersion: "0.0.0.9"))
    }
}

// MARK: - Localization

extension SirenTests {

    func testArabicLocalization() {
        let language: Localization.Language = .arabic

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "التحديث متوفر")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "المرة التالية")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "تخطى عن هذه النسخة")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "تحديث")
    }

    func testArmenianLocalization() {
        let language: Localization.Language = .armenian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Թարմացումը հասանելի Է")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Հաջորդ անգամ")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Բաց թողնել այս տարբերակը")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Թարմացնել")
    }

    func testBasqueLocalization() {
        let language: Localization.Language = .basque

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Eguneratzea erabilgarri")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Hurrengo batean")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Bertsio honetatik jauzi egin")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Eguneratu")
    }

    func testChineseSimplifiedLocalization() {
        let language: Localization.Language = .chineseSimplified

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "更新可用")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "下一次")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "跳过此版本")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "更新")
    }

    func testChineseTraditionalLocalization() {
        let language: Localization.Language = .chineseTraditional

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "有更新可用")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "下次")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "跳過此版本")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "更新")
    }

    func testCroatianLocalization() {
        let language: Localization.Language = .croatian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Novo ažuriranje je dostupno")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Sljedeći put")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Preskoči ovu verziju")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Ažuriraj")
    }

    func testCzechLocalization() {
        let language: Localization.Language = .czech

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Aktualizace dostupná")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Příště")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Přeskočit tuto verzi")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Aktualizovat")
    }

    func testDanishLocalization() {
        let language: Localization.Language = .danish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Tilgængelig opdatering")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Næste gang")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Spring denne version over")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Opdater")
    }

    func testDutchLocalization() {
        let language: Localization.Language = .dutch

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Update beschikbaar")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Volgende keer")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Sla deze versie over")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Updaten")
    }

    func testEstonianLocalization() {
        let language: Localization.Language = .estonian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Uuendus saadaval")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Järgmisel korral")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Jäta see version vahele")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Uuenda")
    }

    func testFinnishLocalization() {
        let language: Localization.Language = .finnish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Päivitys saatavilla")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Ensi kerralla")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Jätä tämä versio väliin")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Päivitys")
    }

    func testFrenchLocalization() {
        let language: Localization.Language = .french

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Mise à jour disponible")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "La prochaine fois")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Sauter cette version")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Mettre à jour")
    }

    func testGermanLocalization() {
        let language: Localization.Language = .german

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Update erhältlich")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Später")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Diese Version überspringen")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Update")
    }

    func testGreekLocalization() {
        let language: Localization.Language = .greek

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Διαθέσιμη Ενημέρωση")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Άλλη φορά")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Αγνόησε αυτήν την έκδοση")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Αναβάθμιση")
    }

    func testHebrewLocalization() {
        let language: Localization.Language = .hebrew

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "עדכון זמין")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "בפעם הבאה")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "דלג על גרסה זו")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "עדכן")
    }

    func testHungarianLocalization() {
        let language: Localization.Language = .hungarian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Új frissítés érhető el")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Később")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Ennél a verziónál ne figyelmeztessen")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Frissítés")
    }

    func testIndonesianLocalization() {
        let language: Localization.Language = .indonesian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Pembaruan Tersedia")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Lain kali")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Lewati versi ini")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Perbarui")
    }

    func testItalianLocalization() {
        let language: Localization.Language = .italian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Aggiornamento disponibile")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "La prossima volta")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Salta questa versione")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Aggiorna")
    }

    func testJapaneseLocalization() {
        let language: Localization.Language = .japanese

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "アップデートのお知らせ")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "次回")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "このバージョンをスキップ")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "アップデート")
    }

    func testKoreanLocalization() {
        let language: Localization.Language = .korean

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "업데이트 가능")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "다음에")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "이 버전 건너뜀")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "업데이트")
    }

    func testLatvianLocalization() {
        let language: Localization.Language = .latvian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Atjauninājums pieejams")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Nākamreiz")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Izlaist šo versiju")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Atjaunināt")
    }

    func testLithuanianLocalization() {
        let language: Localization.Language = .lithuanian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Atnaujinimas")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Kitą kartą")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Praleisti šią versiją")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Atnaujinti")
    }

    func testMalayLocalization() {
        let language: Localization.Language = .malay

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Versi Terkini")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Lain kali")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Langkau versi ini")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Muat turun")
    }

    func testNorwegianLocalization() {
        let language: Localization.Language = .norwegian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Oppdatering tilgjengelig")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Neste gang")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Hopp over denne versjonen")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Oppdater")
    }

    func testPersianLocalization() {
        let language: Localization.Language = .persian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "بروزرسانی در دسترس")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "دفعه بعد")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "رد این نسخه")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "بروزرسانی")
    }

    func testPersianAfghanistanLocalization() {
        let language: Localization.Language = .persianAfghanistan

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "بروزرسانی در دسترس")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "دگر بار")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "رد این نسخه")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "بروزرسانی")
    }

    func testPersianIranLocalization() {
        let language: Localization.Language = .persianIran

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "بروزرسانی در دسترس")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "دفعه بعد")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "رد این نسخه")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "بروزرسانی")
    }

    func testPolishLocalization() {
        let language: Localization.Language = .polish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Aktualizacja dostępna")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Następnym razem")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Pomiń wersję")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Zaktualizuj")
    }

    func testPortugueseBrazilLocalization() {
        let language: Localization.Language = .portugueseBrazil

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Atualização disponível")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Próxima vez")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Ignorar esta versão")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Atualizar")
    }

    func testPortuguesePortugalLocalization() {
        let language: Localization.Language = .portuguesePortugal

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Nova actualização disponível")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Próxima vez")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Ignorar esta versão")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Actualizar")
    }

    func testRomanianLocalization() {
        let language: Localization.Language = .romanian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Actualizare disponibilă")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Data viitoare")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Ignor această versiune")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Actualizare")
    }

    func testRussianLocalization() {
        let language: Localization.Language = .russian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Доступно обновление")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "В следующий раз")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Пропустить эту версию")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Обновить")
    }

    func testSerbianCyrillicLocalization() {
        let language: Localization.Language = .serbianCyrillic

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Ажурирање доступно")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Следећи пут")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Прескочи ову верзију")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Ажурирај")
    }

    func testSerbianLatinLocalization() {
        let language: Localization.Language = .serbianLatin

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Ažuriranje dostupno")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Sledeći put")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Preskoči ovu verziju")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Ažuriraj")
    }

    func testSlovenianLocalization() {
        let language: Localization.Language = .slovenian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Posodobitev aplikacije")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Naslednjič")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Ne želim")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Namesti")
    }

    func testSpanishLocalization() {
        let language: Localization.Language = .spanish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Actualización disponible")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "La próxima vez")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Saltar esta versión")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Actualizar")
    }

    func testSwedishLocalization() {
        let language: Localization.Language = .swedish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Tillgänglig uppdatering")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Nästa gång")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Hoppa över den här versionen")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Uppdatera")
    }

    func testThaiLocalization() {
        let language: Localization.Language = .thai

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "มีการอัพเดท")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "ไว้คราวหน้า")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "ข้ามเวอร์ชั่นนี้")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "อัพเดท")
    }

    func testTurkishLocalization() {
        let language: Localization.Language = .turkish

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Güncelleme Mevcut")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Daha sonra")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Boşver")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Güncelle")
    }

    func testUkrainianLocalization() {
        let language: Localization.Language = .ukrainian

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Доступне Оновлення")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Наступного разу")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Пропустити версію")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Оновити")
    }

    func testUrduLocalization() {
        let language: Localization.Language = .urdu

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "نیا اپڈیٹ")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "اگلی مرتبہ")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "اس ورزن کو چھوڑ دیں")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "اپڈیٹ کریں")
    }

    func testVietnameseLocalization() {
        let language: Localization.Language = .vietnamese

        // Update Available
        XCTAssertEqual(Bundle.localizedString(forKey: "Update Available", andForceLocalization: language), "Cập nhật mới")

        // Next time
        XCTAssertEqual(Bundle.localizedString(forKey: "Next time", andForceLocalization: language), "Lần tới")

        // Skip this version
        XCTAssertEqual(Bundle.localizedString(forKey: "Skip this version", andForceLocalization: language), "Bỏ qua phiên bản này")

        // Update
        XCTAssertEqual(Bundle.localizedString(forKey: "Update", andForceLocalization: language), "Cập nhật")
    }

}
