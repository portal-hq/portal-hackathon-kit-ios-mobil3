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

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Wallet")
                    .font(.title)
                    .bold()

                Spacer()

                PortalButton(title: "Fund Wallet", style: .secondary) {
                    onFundClick?()
                }
                .frame(width: 100, height: 30)

                PortalButton(title: "Backup Wallet", style: .secondary) {
                    showPasswordAlert.toggle()
                }
                .frame(height: 30)
            }
            .padding(.bottom, 10)

            VStack {
                HStack {
                    Text("ADDRESS:")
                        .font(.headline)
                        .bold()

                    Button {
                        onCopyAddressClick?()
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                    Spacer()
                }

                LeadingText(address)
                    .font(.body)
                    .padding(.bottom, 10)

                if let nativeBalance {
                    HStack {
                        Text("Native BALANCE:")
                            .font(.headline)
                            .bold()

                        Button {
                            onRefreshBalanceClick?()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        Spacer()
                    }

                    LeadingText("\(nativeBalance) MON")
                        .font(.body)
                        .padding(.bottom, 10)
                }

                if let USDCBalance {
                    HStack {
                        Text("USDC BALANCE:")
                            .font(.headline)
                            .bold()

                        Button {
                            onRefreshBalanceClick?()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        Spacer()
                    }

                    LeadingText("\(USDCBalance) USDC")
                        .font(.body)
                        .padding(.bottom, 10)
                }

            }
            .padding([.leading, .trailing], 20)
        }
        .alert("Enter Password", isPresented: $showPasswordAlert) {
            SecureField("PASSWORD", text: $backupPassword)
                .keyboardType(.numberPad)
                .textContentType(.password)

            Button("Submit") {
                onBackupWalletClick?(backupPassword)
            }
            Button("Cancel", role: .cancel, action: {})
        }
    }
}

#Preview {
    PortalWalletView(address: "the address should be here...", nativeBalance: "5", USDCBalance: "100")
}
