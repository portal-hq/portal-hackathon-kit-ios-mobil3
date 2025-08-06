//
//  PortalTransactionHashView.swift
//  PortalHackathonKit
//

import SwiftUI

/// Reusable Transaction Hash View
struct PortalTransactionHashView: View {

    let transactionHash: String
    var onCopyTransactionHashClick: (() -> Void)?

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                LeadingText("Transaction:", isLabel: true)

                Button {
                    onCopyTransactionHashClick?()
                } label: {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(Constants.Theme.primaryBlue)
                }
                Spacer()
            }

            HStack {
                Text(transactionHash)
                    .foregroundColor(Constants.Theme.textColor)
                    .font(.body)
                    .padding()
                    .background(Constants.Theme.secondaryBackground)
                    .cornerRadius(5)
                Spacer()
            }
        }

    }
}

#Preview {
    PortalTransactionHashView(transactionHash: "0xabcd...1234")
}
