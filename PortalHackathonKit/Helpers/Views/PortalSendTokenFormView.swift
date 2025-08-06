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
        VStack {
            LeadingText("Transfer Tokens")
                .font(.title)
                .bold()
                .padding(.bottom, 10)

            VStack {
                LeadingText("RECIPIENT")
                    .font(.subheadline)

                TextField("Recipient Address", text: $recipientAddress)
                    .frame(height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))
                    .padding(.bottom)

                LeadingText("AMOUNT")
                    .font(.subheadline)

                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
                    .frame(height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))

                HStack {
                    Text("Select Token:")
                        .font(.headline)
                        .bold()

                    Spacer()

                    Picker("", selection: self.$tokenSymbol) {
                        Text("MON").tag("MON")
                        Text("USDC").tag("USDC")
                    }
                }
                .pickerStyle(DefaultPickerStyle())

                PortalButton(title: "Send \(tokenSymbol)") {
                    onSendPress?()
                }
                .frame(height: 45)
                .padding(.top)
            }
            .padding([.leading, .trailing], 20)
        }
    }
}

#Preview {
    PortalSendTokenFormView(recipientAddress: .constant(""), amount: .constant(""), tokenSymbol: .constant(""))
}
