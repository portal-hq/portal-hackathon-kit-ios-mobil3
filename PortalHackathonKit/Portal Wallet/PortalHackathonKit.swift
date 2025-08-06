//
//  PortalHackathonKit.swift
//  PortalHackathonKit
//

import SwiftUI

struct PortalHackathonKit: View {

    // PortalWalletViewModel handles all the Portal Logic
    @ObservedObject private var portalWalletViewModel = PortalWalletViewModel()

    // MARK: - properties
    @State private var recipientAddress: String = ""
    @State private var amount: String = ""
    @State private var tokenSymbol: String = "MON"

    var body: some View {
        ScrollView {
            VStack {
                switch portalWalletViewModel.state {
                case .loading:
                    // Loader
                    ProgressView()
                        .scaleEffect(2)
                        .tint(.blue)

                case let .portalInitialized(isRecoverAvailable):
                    // Generate or Recover Wallet View
                    PortalInitializedView(isRecoverAvailable: isRecoverAvailable, onGenerateWalletClicked: {
                        portalWalletViewModel.generateWallet()
                    }) { password in
                        portalWalletViewModel.recoverWallet(with: password)
                    }

                case let .generated(address, assets, transactionHash):
                    // Wallet Data View
                    PortalWalletView(
                        address: address,
                        nativeBalance: assets?.nativeBalance ?? "-",
                        USDCBalance: assets?.USDCBalance ?? "-",
                        onCopyAddressClick: {
                            portalWalletViewModel.copyAddress()
                        },
                        onRefreshBalanceClick: {
                            portalWalletViewModel.getBalance()
                        },
                        onBackupWalletClick: { password in
                            portalWalletViewModel.backupWallet(with: password)
                        },
                        onFundClick: {
                            portalWalletViewModel.fundTestnetWallet()
                        }
                    )

                    // Send Token Form View
                    PortalSendTokenFormView(recipientAddress: $recipientAddress, amount: $amount, tokenSymbol: $tokenSymbol) {
                        portalWalletViewModel.transfer(recipient: recipientAddress, amount: amount, tokenSymbol: tokenSymbol)
                    }

                    // The Sent transaction hash
                    if let transactionHash {
                        PortalTransactionHashView(transactionHash: transactionHash) {
                            portalWalletViewModel.copyTransactionHash()
                        }
                    }

                    // Bottom space
                    Spacer()
                case .error(let errorMessage):
                    // Label to show the error
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            .frame(minHeight: UIScreen.main.bounds.height - 32)
            .padding()
        }
    }
}

#Preview {
    PortalHackathonKit()
}
