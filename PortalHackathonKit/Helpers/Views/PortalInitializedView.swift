//
//  PortalInitializedView.swift
//  PortalHackathonKit
//

import SwiftUI

struct PortalInitializedView: View {

    let isRecoverAvailable: Bool
    var onGenerateWalletClicked: (() -> Void)?
    var onRecoverWalletClicked: ((_ password: String) -> Void)?

    @State private var showPasswordAlert = false
    @State private var recoverPassword: String = ""

    var body: some View {
        VStack(spacing: 20) {
            if isRecoverAvailable {
                Text("Wallet found. Ready to recover?")
                    .foregroundColor(Constants.Theme.textColor)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .fontWeight(.bold)
            } else {
                Text("Ready to create your wallet?")
                    .foregroundColor(Constants.Theme.textColor)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .fontWeight(.bold)
            }

            PortalButton(title: "Create Wallet") {
                onGenerateWalletClicked?()
            }
            .frame(width: 250, height: 50)

            if isRecoverAvailable {
                PortalButton(title: "Recover", style: .secondary) {
                    showPasswordAlert.toggle()
                }
                .frame(width: 250, height: 50)
            }
        }
        .alert("Recover Wallet", isPresented: $showPasswordAlert) {
            SecureField("Password", text: $recoverPassword)
                .keyboardType(.numberPad)
                .textContentType(.password)

            Button("Recover") {
                onRecoverWalletClicked?(recoverPassword)
            }
            Button("Cancel", role: .cancel, action: {})
        }
    }
}

#Preview {
    PortalInitializedView(isRecoverAvailable: false)
}
