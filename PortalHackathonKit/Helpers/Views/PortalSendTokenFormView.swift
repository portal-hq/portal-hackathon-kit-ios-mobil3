//
//  PortalSendTokenFormView.swift
//  PortalHackathonKit
//

import SwiftUI

/// Reusable Send Token Form View.
struct PortalSendTokenFormView: View {
    @Binding var recipientAddress: String
    @Binding var amount: String
    @Binding var tokenSymbol: String

    var onSendPress: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Send Tokens")
                    .foregroundColor(Constants.Theme.textColor)
                    .font(.headline)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .kerning(1)
                    .padding(.top, 24)
                Spacer()
            }

            VStack(spacing: 12) {
                HStack {
                    Text("Token:")
                        .foregroundColor(Constants.Theme.textColor)
                        .font(.caption)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .kerning(1)
                    Spacer()
                }

                HStack(spacing: 10) {
                    // MON Toggle
                    Button {
                        tokenSymbol = "MON"
                    } label: {
                        Text("MON")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Constants.Theme.textColor)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(tokenSymbol == "MON" ? Constants.Theme.primaryBlue : Constants.Theme.secondaryBackground)
                            .cornerRadius(5)
                    }

                    // USDC Toggle
                    Button {
                        tokenSymbol = "USDC"
                    } label: {
                        Text("USDC")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Constants.Theme.textColor)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(tokenSymbol == "USDC" ? Constants.Theme.primaryBlue : Constants.Theme.secondaryBackground)
                            .cornerRadius(5)
                    }
                }
            }

            // Recipient Address Section
            VStack(spacing: 12) {
                HStack {
                    Text("To:")
                        .foregroundColor(Constants.Theme.textColor)
                        .font(.caption)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .kerning(1)
                    Spacer()
                }

                TextField("Wallet address", text: $recipientAddress)
                    .foregroundColor(Constants.Theme.textColor)
                    .padding()
                    .background(Constants.Theme.secondaryBackground)
                    .cornerRadius(5)
                    .frame(height: 50)
            }

            // Amount Section
            VStack(spacing: 12) {
                HStack {
                    Text("Amount:")
                        .foregroundColor(Constants.Theme.textColor)
                        .font(.caption)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .kerning(1)
                    Spacer()
                }

                TextField("0.0", text: $amount)
                    .foregroundColor(Constants.Theme.textColor)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Constants.Theme.secondaryBackground)
                    .cornerRadius(5)
                    .frame(height: 50)
            }

            PortalButton(title: "Send \(tokenSymbol)") {
                onSendPress?()
            }
            .frame(height: 50)
        }
    }
}

#Preview {
    PortalSendTokenFormView(recipientAddress: .constant(""), amount: .constant(""), tokenSymbol: .constant(""))
}
