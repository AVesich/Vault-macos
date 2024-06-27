//
//  EngineFilter.swift
//  Vault
//
//  Created by Austin Vesich on 6/25/24.
//

import SwiftUI

struct SearchFilter {
    let name: String
    let iconName: String
    let selectAction: () -> ()
    let deselectAction: (() -> ())?
}
