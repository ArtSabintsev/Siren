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

    let siren = Siren.sharedInstance

}

// MARK: - Updates

extension SirenTests {

    func testSingleDigitVersionUpdate() {
        siren.testSetCurrentInstalledVersion("1")

        siren.testSetAppStoreVersion("2")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())
    }

    func testDoubleDigitVersionUpdate() {
        siren.testSetCurrentInstalledVersion("1.0")

        siren.testSetAppStoreVersion("2")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())
    }

    func testTripleDigitVersionUpdate() {
        siren.testSetCurrentInstalledVersion("1.0.0")

        siren.testSetAppStoreVersion("2")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())
    }

    func testQuadrupleDigitVersionUpdate() {
        siren.testSetCurrentInstalledVersion("1.0.0")

        siren.testSetAppStoreVersion("2")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("2.0.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion("0.0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())
    }

}


// MARK: - Localization

extension SirenTests {

    func testArabicLocalization() {
        let language: SirenLanguageType = .Arabic
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "التجديد متوفر")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "المرة التالية")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "تخطى عن هذه النسخة")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "تجديد")
    }

    func testArmenianLocalization() {
        let language: SirenLanguageType = .Armenian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Թարմացումը հասանելի Է")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Հաջորդ անգամ")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Բաց թողնել այս տարբերակը")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Թարմացնել")
    }

    func testBasqueLocalization() {
        let language: SirenLanguageType = .Basque
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Eguneratzea erabilgarri")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Hurrengo batean")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Bertsio honetatik jauzi egin")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Eguneratu")
    }

    func testChineseSimplifiedLocalization() {
        let language: SirenLanguageType = .ChineseSimplified
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "更新可用")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "下一次")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "跳过此版本")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "更新")
    }

    func testChineseTraditionalLocalization() {
        let language: SirenLanguageType = .ChineseTraditional
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "有更新可用")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "下次")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "跳過此版本")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "更新")
    }

    func testCroatianLocalization() {
        let language: SirenLanguageType = .Croatian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Nova ažuriranje je stigla")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Sljedeći put")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Preskoči ovu verziju")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Ažuriraj")
    }

    func testDanishLocalization() {
        let language: SirenLanguageType = .Danish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Tilgængelig opdatering")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Næste gang")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Spring denne version over")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Opdater")
    }

    func testDutchLocalization() {
        let language: SirenLanguageType = .Dutch
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Update Beschikbaar")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Volgende keer")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Sla deze versie over")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Updaten")
    }

    func testEstonianLocalization() {
        let language: SirenLanguageType = .Estonian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Uuendus saadaval")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Järgmisel korral")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Jäta see version vahele")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Uuenda")
    }

    func testFrenchLocalization() {
        let language: SirenLanguageType = .French
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Mise à jour disponible")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "La prochaine fois")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Sauter cette version")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Mettre à jour")
    }

    func testGermanLocalization() {
        let language: SirenLanguageType = .German
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Update erhältlich")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Später")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Diese Version überspringen")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Update")
    }

    func testHebrewLocalization() {
        let language: SirenLanguageType = .Hebrew
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "עדכון זמין")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "בפעם הבאה")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "דלג על גרסה זו")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "עדכן")
    }

    func testHungarianLocalization() {
        let language: SirenLanguageType = .Hungarian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Új frissítés érhető el")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Később")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Ennél a verziónál ne figyelmeztessen")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Frissítés")
    }

    func testItalianLocalization() {
        let language: SirenLanguageType = .Italian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Aggiornamento disponibile")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "La prossima volta")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Salta questa versione")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Aggiorna")
    }

    func testJapaneseLocalization() {
        let language: SirenLanguageType = .Japanese
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "更新が利用可能")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "次回")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "このバージョンをスキップ")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "更新")
    }

    func testKoreanLocalization() {
        let language: SirenLanguageType = .Korean
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "업데이트 가능")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "다음에")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "이 버전 건너뜀")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "업데이트")
    }

    func testLatvianLocalization() {
        let language: SirenLanguageType = .Latvian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Atjaunojums")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Nākošreiz")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Palaist garām šo versiju")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Atjaunot")
    }

    func testLithuanianLocalization() {
        let language: SirenLanguageType = .Lithuanian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Atnaujinimas")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Kitą kartą")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Praleisti šią versiją")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Atnaujinti")
    }

    func testMalayLocalization() {
        let language: SirenLanguageType = .Malay
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Versi Terkini")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Lain kali")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Langkau versi ini")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Muat turun")
    }

    func testPolishLocalization() {
        let language: SirenLanguageType = .Polish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Aktualizacja dostępna")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Następnym razem")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Pomiń wersję")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Zaktualizuj")
    }

    func testPortugueseBrazilLocalization() {
        let language: SirenLanguageType = .PortugueseBrazil
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Nova atualização disponível")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Próxima vez")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Ignorar esta versão")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Atualizar")
    }

    func testPortuguesePortugalLocalization() {
        let language: SirenLanguageType = .PortuguesePortugal
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Nova actualização disponível")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Próxima vez")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Ignorar esta versão")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Actualizar")
    }

    func testRussianLocalization() {
        let language: SirenLanguageType = .Russian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Доступно обновление")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "В следующий раз")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Пропустить эту версию")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Обновить")
    }

    func testSlovenianLocalization() {
        let language: SirenLanguageType = .Slovenian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Posodobitev aplikacije")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Naslednjič")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Ne želim")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Namesti")
    }

    func testSpanishLocalization() {
        let language: SirenLanguageType = .Spanish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Actualización disponible")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "La próxima vez")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Saltar esta versión")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Actualizar")
    }

    func testSwedishLocalization() {
        let language: SirenLanguageType = .Swedish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Tillgänglig uppdatering")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Nästa gång")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Hoppa över den här versionen")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Uppdatera")
    }

    func testThaiLocalization() {
        let language: SirenLanguageType = .Thai
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "มีการอัพเดท")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "ไว้คราวหน้า")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "ข้ามเวอร์ชั่นนี้")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "อัพเดท")
    }

    func testTurkishLocalization() {
        let language: SirenLanguageType = .Turkish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(NSBundle().testLocalizedString("Update Available", forceLanguageLocalization: language), "Güncelleme Mevcut")

        // Next time
        XCTAssertEqual(siren.localizedNextTimeButtonTitle(), "Daha sonra")

        // Skip this version
        XCTAssertEqual(siren.localizedSkipButtonTitle(), "Boşver")

        // Update
        XCTAssertEqual(siren.localizedUpdateButtonTitle(), "Güncelle")
    }

}
