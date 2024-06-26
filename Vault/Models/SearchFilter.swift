//
//  EngineFilter.swift
//  Vault
//
//  Created by Austin Vesich on 6/25/24.
//

import SwiftUI

struct SearchFilter: Identifiable {
    let id = UUID()
    let name: String?
    let iconName: String
    let selectAction: () -> ()
    let deselectAction: (() -> ())?
}
