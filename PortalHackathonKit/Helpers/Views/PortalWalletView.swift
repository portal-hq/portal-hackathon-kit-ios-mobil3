//
//  PortalWalletView.swift
//  PortalHackathonKit
//

import SwiftUI

/// Reusable Wallet View
struct PortalWalletView: View {
    let address: String
    let nativeBalance: String?
    let USDCBalance: String?

    var onCopyAddressClick: (() -> Void)?
    var onRefreshBalanceClick: (() -> Void)?
    var onBackupWalletClick: ((_ password: String) -> Void)?
    var onFundClick: (() -> Void)?

    @State private var showPasswordAlert = false
    @State private var backupPassword: String = ""

    // Helper function to truncate address
    private func truncateAddress(_ address: String) -> String {
        guard address.count > 10 else { return address }
        let prefix = String(address.prefix(22))
        let suffix = String(address.suffix(4))
        return "\(prefix)...\(suffix)"
    }

    // Helper function to format balance (show 0 instead of nil or -)
    private func formatBalance(_ balance: String?) -> String {
        guard let balance = balance, !balance.isEmpty, balance != "-" else {
            return "0"
        }
        return balance
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Portal Wallet")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Constants.Theme.textColor)
                Spacer()
            }

            VStack(spacing: 12) {
                HStack {
                    Text("Address:")
                        .foregroundColor(Constants.Theme.textColor)
                        .font(.headline)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .kerning(1)
                    Spacer()
                }

                HStack(spacing: 8) {
                    Text(truncateAddress(address))
                        .foregroundColor(Constants.Theme.textColor)
                        .font(.callout)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Constants.Theme.secondaryBackground)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Button {
                        onCopyAddressClick?()
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(Constants.Theme.primaryBlue)
                            .font(.title3)
                    }
                }
            }

            // Fund and Backup buttons underneath address
            HStack(spacing: 12) {
                PortalButton(title: "Fund", style: .secondary) {
                    onFundClick?()
                }
                .frame(height: 44)

                PortalButton(title: "Backup", style: .secondary) {
                    showPasswordAlert.toggle()
                }
                .frame(height: 44)
            }

            VStack(spacing: 12) {
                HStack {
                    Text("Balances:")
                        .foregroundColor(Constants.Theme.textColor)
                        .font(.headline)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .kerning(1)
                        .padding(.top, 12)
                    Spacer()
                }

                VStack(spacing: 6) {
                    HStack {
                        Text("MON")
                            .foregroundColor(Constants.Theme.textColor)
                            .font(.caption)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                        Spacer()
                        Text(formatBalance(nativeBalance) + " MON")
                            .foregroundColor(Constants.Theme.textColor)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .cornerRadius(8)

                    // USDC Balance - Full Width
                    HStack {
                        Text("USDC")
                            .foregroundColor(Constants.Theme.textColor)
                            .font(.caption)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                        Spacer()
                        Text(formatBalance(USDCBalance) + " USDC")
                            .foregroundColor(Constants.Theme.textColor)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .cornerRadius(8)
                }

                PortalButton(title: "Refresh Balances", style: .secondary) {
                    onRefreshBalanceClick?()
                }
                .frame(height: 50)
            }
        }
        .alert("Backup Wallet", isPresented: $showPasswordAlert) {
            SecureField("Password", text: $backupPassword)
                .keyboardType(.numberPad)
                .textContentType(.password)

            Button("Backup") {
                onBackupWalletClick?(backupPassword)
            }
            Button("Cancel", role: .cancel, action: {})
        }
    }
}

#Preview {
    PortalWalletView(address: "0x35ff2c11b5f6024cdd95e890867e851489ae032a", nativeBalance: "5.0", USDCBalance: "100.0")
}
