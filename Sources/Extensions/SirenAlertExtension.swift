//
//  SirenAlertExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Helpers (Alert)

extension Siren {
    func showAlertIfCurrentAppStoreVersionNotSkipped() {
        alertType = setAlertType()

        guard let previouslySkippedVersion = UserDefaults.standard.object(forKey: SirenDefaults.StoredSkippedVersion.rawValue) as? String else {
            showAlert()
            return
        }

        if let currentAppStoreVersion = currentAppStoreVersion, currentAppStoreVersion != previouslySkippedVersion {
            showAlert()
        }
    }

    func showAlert() {
        storeVersionCheckDate()

        let updateAvailableMessage = localizedUpdateAvailableMessage()
        let newVersionMessage = localizedNewVersionMessage()

        let alertController = UIAlertController(title: updateAvailableMessage, message: newVersionMessage, preferredStyle: .alert)

        if let alertControllerTintColor = alertControllerTintColor {
            alertController.view.tintColor = alertControllerTintColor
        }

        switch alertType {
        case .force:
            alertController.addAction(updateAlertAction())
        case .option:
            alertController.addAction(nextTimeAlertAction())
            alertController.addAction(updateAlertAction())
        case .skip:
            alertController.addAction(nextTimeAlertAction())
            alertController.addAction(updateAlertAction())
            alertController.addAction(skipAlertAction())
        case .none:
            let updateTitle = localizedUpdateTitle()
            delegate?.sirenDidDetectNewVersionWithoutAlert(title: updateTitle, message: newVersionMessage, updateType: updateType)
        }

        if alertType != .none && !alertViewIsVisible {
            alertController.show()
            alertViewIsVisible = true
            delegate?.sirenDidShowUpdateDialog(alertType: alertType)
        }
    }

    func updateAlertAction() -> UIAlertAction {
        let title = localizedUpdateButtonTitle()
        let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.hideWindow()
            self.launchAppStore()
            self.delegate?.sirenUserDidLaunchAppStore()
            self.alertViewIsVisible = false
            return
        }

        return action
    }

    func nextTimeAlertAction() -> UIAlertAction {
        let title = localizedNextTimeButtonTitle()
        let action = UIAlertAction(title: title, style: .default) { [weak self] _  in
            guard let self = self else { return }

            self.hideWindow()
            self.delegate?.sirenUserDidCancel()
            self.alertViewIsVisible = false
            return
        }

        return action
    }

    func skipAlertAction() -> UIAlertAction {
        let title = localizedSkipButtonTitle()
        let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self = self else { return }

            if let currentAppStoreVersion = self.currentAppStoreVersion {
                UserDefaults.standard.set(currentAppStoreVersion, forKey: SirenDefaults.StoredSkippedVersion.rawValue)
                UserDefaults.standard.synchronize()
            }

            self.hideWindow()
            self.delegate?.sirenUserDidSkipVersion()
            self.alertViewIsVisible = false
            return
        }

        return action
    }

    func setAlertType() -> Siren.AlertType {
        guard let currentInstalledVersion = currentInstalledVersion,
            let currentAppStoreVersion = currentAppStoreVersion else {
                return .option
        }

        let oldVersion = (currentInstalledVersion).lazy.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
        let newVersion = (currentAppStoreVersion).lazy.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}

        guard let newVersionFirst = newVersion.first, let oldVersionFirst = oldVersion.first else {
            return alertType // Default value is .Option
        }

        if newVersionFirst > oldVersionFirst { // A.b.c.d
            alertType = majorUpdateAlertType
            updateType = .major
        } else if newVersion.count > 1 && (oldVersion.count <= 1 || newVersion[1] > oldVersion[1]) { // a.B.c.d
            alertType = minorUpdateAlertType
            updateType = .minor
        } else if newVersion.count > 2 && (oldVersion.count <= 2 || newVersion[2] > oldVersion[2]) { // a.b.C.d
            alertType = patchUpdateAlertType
            updateType = .patch
        } else if newVersion.count > 3 && (oldVersion.count <= 3 || newVersion[3] > oldVersion[3]) { // a.b.c.D
            alertType = revisionUpdateAlertType
            updateType = .revision
        }

        return alertType
    }
}
