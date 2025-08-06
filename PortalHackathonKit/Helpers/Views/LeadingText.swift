//
//  LeadingText.swift
//  PortalHackathonKit
//

import SwiftUI

/// Reusable Leading Text View
struct LeadingText: View {
    let text: String
    var isLabel: Bool = false

    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(Constants.Theme.textColor)
                .font(isLabel ? .caption : .body)
                .fontWeight(isLabel ? .bold : .regular)
                .textCase(isLabel ? .uppercase : nil)
                .kerning(isLabel ? 1 : 0)
            Spacer()
        }
    }

    init(_ text: String, isLabel: Bool = false) {
        self.text = text
        self.isLabel = isLabel
    }
}

#Preview {
    LeadingText("Wallet")
}
