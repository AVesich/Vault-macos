//
//  URLExtension.swift
//  Vault
//
//  Created by Austin Vesich on 6/2/24.
//

import Foundation
import SwiftUI

extension URL {
    var fileImage: Image {
        let fileIcon = NSWorkspace.shared.icon(forFile: self.relativePath)
        return Image(nsImage: fileIcon)
    }
}
