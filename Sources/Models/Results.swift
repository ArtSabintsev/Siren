//
//  Results.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/1/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

public struct Results {
    public var alertAction: AlertAction = .unknown

    public var localization: Localization

    public var lookupModel: LookupModel?

    public var updateType: RulesManager.UpdateType = .unknown
}
