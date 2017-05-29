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

    let siren = Siren.shared

}

// MARK: - Updates

extension SirenTests {

    func testSingleDigitVersionUpdate() {
        siren.testSetCurrentInstalledVersion(version: "1")

        siren.testSetAppStoreVersion(version: "2")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())
    }

    func testDoubleDigitVersionUpdate() {
        siren.testSetCurrentInstalledVersion(version: "1.0")

        siren.testSetAppStoreVersion(version: "2")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())
    }

    func testTripleDigitVersionUpdate() {
        siren.testSetCurrentInstalledVersion(version: "1.0.0")

        siren.testSetAppStoreVersion(version: "2")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())
    }

    func testQuadrupleDigitVersionUpdate() {
        siren.testSetCurrentInstalledVersion(version: "1.0.0")

        siren.testSetAppStoreVersion(version: "2")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "2.0.0.0")
        XCTAssertTrue(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())

        siren.testSetAppStoreVersion(version: "0.0.0.9")
        XCTAssertFalse(siren.testIsAppStoreVersionNewer())
    }

}


// MARK: - Localization

extension SirenTests {

    func testArabicLocalization() {
        let language: Siren.LanguageType = .Arabic
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "التجديد متوفر")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "المرة التالية")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "تخطى عن هذه النسخة")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "تجديد")
    }

    func testArmenianLocalization() {
        let language: Siren.LanguageType = .Armenian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Թարմացումը հասանելի Է")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Հաջորդ անգամ")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Բաց թողնել այս տարբերակը")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Թարմացնել")
    }

    func testBasqueLocalization() {
        let language: Siren.LanguageType = .Basque
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Eguneratzea erabilgarri")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Hurrengo batean")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Bertsio honetatik jauzi egin")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Eguneratu")
    }

    func testChineseSimplifiedLocalization() {
        let language: Siren.LanguageType = .ChineseSimplified
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "更新可用")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "下一次")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "跳过此版本")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "更新")
    }

    func testChineseTraditionalLocalization() {
        let language: Siren.LanguageType = .ChineseTraditional
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "有更新可用")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "下次")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "跳過此版本")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "更新")
    }

    func testCroatianLocalization() {
        let language: Siren.LanguageType = .Croatian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Nova ažuriranje je stigla")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Sljedeći put")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Preskoči ovu verziju")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Ažuriraj")
    }

    func testCzechLocalization() {
        let language: Siren.LanguageType = .Czech
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Aktualizace dostupná")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Příště")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Přeskočit tuto verzi")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Aktualizovat")
    }

    func testDanishLocalization() {
        let language: Siren.LanguageType = .Danish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Tilgængelig opdatering")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Næste gang")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Spring denne version over")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Opdater")
    }

    func testDutchLocalization() {
        let language: Siren.LanguageType = .Dutch
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Update Beschikbaar")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Volgende keer")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Sla deze versie over")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Updaten")
    }

    func testEstonianLocalization() {
        let language: Siren.LanguageType = .Estonian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Uuendus saadaval")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Järgmisel korral")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Jäta see version vahele")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Uuenda")
    }

    func testFinnishLocalization() {
        let language: Siren.LanguageType = .Finnish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Päivitys saatavilla")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Ensi kerralla")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Jätä tämä versio väliin")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Päivitys")
    }

    func testFrenchLocalization() {
        let language: Siren.LanguageType = .French
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Mise à jour disponible")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "La prochaine fois")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Sauter cette version")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Mettre à jour")
    }

    func testGermanLocalization() {
        let language: Siren.LanguageType = .German
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Update erhältlich")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Später")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Diese Version überspringen")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Update")
    }
    
    func testGreekLocalization() {
        let language: Siren.LanguageType = .Greek
        siren.forceLanguageLocalization = language
        
        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Διαθέσιμη Ενημέρωση")
        
        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Άλλη φορά")
        
        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Αγνόησε αυτήν την έκδοση")
        
        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Αναβάθμιση")
    }

    func testHebrewLocalization() {
        let language: Siren.LanguageType = .Hebrew
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "עדכון זמין")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "בפעם הבאה")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "דלג על גרסה זו")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "עדכן")
    }

    func testHungarianLocalization() {
        let language: Siren.LanguageType = .Hungarian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Új frissítés érhető el")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Később")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Ennél a verziónál ne figyelmeztessen")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Frissítés")
    }

    func testIndonesianLocalization() {
        let language: Siren.LanguageType = .Indonesian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Pembaruan Tersedia")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Lain kali")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Lewati versi ini")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Perbarui")
    }

    func testItalianLocalization() {
        let language: Siren.LanguageType = .Italian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Aggiornamento disponibile")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "La prossima volta")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Salta questa versione")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Aggiorna")
    }

    func testJapaneseLocalization() {
        let language: Siren.LanguageType = .Japanese
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "更新が利用可能")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "次回")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "このバージョンをスキップ")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "更新")
    }

    func testKoreanLocalization() {
        let language: Siren.LanguageType = .Korean
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "업데이트 가능")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "다음에")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "이 버전 건너뜀")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "업데이트")
    }

    func testLatvianLocalization() {
        let language: Siren.LanguageType = .Latvian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Atjauninājums pieejams")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Nākamreiz")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Izlaist šo versiju")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Atjaunināt")
    }

    func testLithuanianLocalization() {
        let language: Siren.LanguageType = .Lithuanian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Atnaujinimas")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Kitą kartą")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Praleisti šią versiją")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Atnaujinti")
    }

    func testMalayLocalization() {
        let language: Siren.LanguageType = .Malay
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Versi Terkini")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Lain kali")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Langkau versi ini")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Muat turun")
    }

    func testNorwegianLocalization() {
        let language: Siren.LanguageType = .Norwegian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Oppdatering tilgjengelig")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Neste gang")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Hopp over denne versjonen")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Oppdater")
    }

    func testPolishLocalization() {
        let language: Siren.LanguageType = .Polish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Aktualizacja dostępna")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Następnym razem")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Pomiń wersję")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Zaktualizuj")
    }

    func testPortugueseBrazilLocalization() {
        let language: Siren.LanguageType = .PortugueseBrazil
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Atualização disponível")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Próxima vez")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Ignorar esta versão")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Atualizar")
    }

    func testPortuguesePortugalLocalization() {
        let language: Siren.LanguageType = .PortuguesePortugal
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Nova actualização disponível")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Próxima vez")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Ignorar esta versão")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Actualizar")
    }

    func testRussianLocalization() {
        let language: Siren.LanguageType = .Russian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Доступно обновление")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "В следующий раз")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Пропустить эту версию")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Обновить")
    }

    func testSerbianCyrillicLocalization() {
        let language: Siren.LanguageType = .SerbianCyrillic
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Ажурирање доступно")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Следећи пут")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Прескочи ову верзију")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Ажурирај")
    }

    func testSerbianLatinLocalization() {
        let language: Siren.LanguageType = .SerbianLatin
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Ažuriranje dostupno")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Sledeći put")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Preskoči ovu verziju")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Ažuriraj")
    }

    func testSlovenianLocalization() {
        let language: Siren.LanguageType = .Slovenian
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Posodobitev aplikacije")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Naslednjič")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Ne želim")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Namesti")
    }

    func testSpanishLocalization() {
        let language: Siren.LanguageType = .Spanish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Actualización disponible")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "La próxima vez")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Saltar esta versión")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Actualizar")
    }

    func testSwedishLocalization() {
        let language: Siren.LanguageType = .Swedish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Tillgänglig uppdatering")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Nästa gång")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Hoppa över den här versionen")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Uppdatera")
    }

    func testThaiLocalization() {
        let language: Siren.LanguageType = .Thai
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "มีการอัพเดท")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "ไว้คราวหน้า")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "ข้ามเวอร์ชั่นนี้")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "อัพเดท")
    }

    func testTurkishLocalization() {
        let language: Siren.LanguageType = .Turkish
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Güncelleme Mevcut")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Daha sonra")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Boşver")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Güncelle")
    }
    
    func testVietnameseLocalization() {
        let language: Siren.LanguageType = .Vietnamese
        siren.forceLanguageLocalization = language

        // Update Available
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update Available", forceLanguageLocalization: language), "Cập nhật mới")

        // Next time
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Next time", forceLanguageLocalization: language), "Lần tới")

        // Skip this version
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Skip this version", forceLanguageLocalization: language), "Bỏ qua phiên bản này")

        // Update
        XCTAssertEqual(Bundle().testLocalizedString(stringKey: "Update", forceLanguageLocalization: language), "Cập nhật")
    }
    
}
