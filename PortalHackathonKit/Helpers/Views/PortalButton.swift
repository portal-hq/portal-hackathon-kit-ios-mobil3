//
//  PortalButton.swift
//  PortalHackathonKit
//

import SwiftUI

enum ButtonStyle {
    case primary
    case secondary
}

/// Reusable button View
struct PortalButton: View {
    var title: String?
    var style: ButtonStyle = .primary
    var onPress: (() -> Void)?
    var cornerRadius: CGFloat = 5 // Reduced to match React Native version (5px)

    var body: some View {
        GeometryReader { geometry in
            getButton(for: geometry, style: style)
        }
    }

    @ViewBuilder func getButton(for geometry: GeometryProxy, style: ButtonStyle) -> some View {
        Button {
            onPress?()
        } label: {
            Text(title ?? "")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(getForegroundColor(for: style))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .background(getBackgroundColor(for: style))
        .cornerRadius(cornerRadius)
        .clipped()
    }

    func getBackgroundColor(for style: ButtonStyle) -> Color {
        switch(style){
        case .primary:
            return Constants.Theme.primaryBlue // #007BFF Blue accent
        case .secondary:
            return Constants.Theme.secondaryBackground // #333 Dark gray
        }
    }

    func getForegroundColor(for style: ButtonStyle) -> Color {
        switch(style){
        case .primary, .secondary:
            return Constants.Theme.textColor // #FFF White text for both
        }
    }
}

#Preview {
    PortalButton()
        .previewLayout(.fixed(width: 200, height: 80))
}
