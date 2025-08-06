//
//  Constants.swift
//  PortalHackathonKit
//

import Foundation
import SwiftUI

enum Constants {
    static var PORTAL_CLIENT_API_KEY: String {
        return "YOUR PORTAL CLIENT API KEY"
    }

    // Monad Testnet Token Addresses
    static let USDC_TESTNET_ADDRESS = "0xf817257fed379853cDe0fa4F97AB987181B1E5Ea"
}

// MARK: - Theme Colors
extension Constants {
    struct Theme {
        // Dark theme colors matching React Native version
        static let backgroundColor = Color(hex: "000000")      // #000 - Dark background
        static let textColor = Color(hex: "FFFFFF")           // #FFF - White text
        static let secondaryBackground = Color(hex: "333333")  // #333 - Dark gray elements
        static let primaryBlue = Color(hex: "007BFF")         // #007BFF - Blue accent
        static let modalBackground = Color(hex: "000000").opacity(0.95) // rgba(0,0,0,0.95) - Semi-transparent dark modal
    }
}

// MARK: - Color Extension for Hex Values
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
