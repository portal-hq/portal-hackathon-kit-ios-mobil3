//
//  PortalWalletViewModel.swift
//  PortalHackathonKit
//

import UIKit
import PortalSwift

/// ``PortalWalletViewModel`` handles all the Portal Logic
public final class PortalWalletViewModel: ObservableObject {

    enum walletUIState {
        case loading
        case portalInitialized(isRecoverAvailable: Bool)
        case generated(address: String, Assets: Assets?, transactionHash: String?)
        case error(errorMessage: String)
    }

    // MARK: - Properties
    private var portal: Portal?
    private var clientAPIKey: String = Constants.PORTAL_CLIENT_API_KEY
    private var isPasswordRecoverAvailable: Bool = false
    private var walletAddress: String?
    private var assets: Assets?
    private var transactionHash: String?
    private let chainId: String = "eip155:10143" // Monad Testnet

    // MARK: - UI Properties
    @Published private(set) var state: walletUIState = .loading

    init() {
        initializePortal()
    }

}

// MARK: - Presentation Helpers
private extension PortalWalletViewModel {
    /// refresh the UI displaying the ``walletAddress``, ``assets``  and ``transactionHash``
    func refreshWalletUI() {
        if let walletAddress {
            setState(
                .generated(address: walletAddress, Assets: assets, transactionHash: transactionHash)
            )
        }
    }

    /// set the ``state`` property on the ``MainThread`` to change it safely from any ``Async`` context.
    func setState(_ state: walletUIState) {
        Task { @MainActor in
            self.state = state
        }
    }
}

// MARK: - Copy helpers
extension PortalWalletViewModel {
    /// Copy the wallet address to the clip board
    func copyAddress() {
        UIPasteboard.general.string = walletAddress
    }

    /// Copy the recent transaction hash to the clip board
    func copyTransactionHash() {
        UIPasteboard.general.string = transactionHash
    }
}

// MARK: - Initialize Portal
private extension PortalWalletViewModel {
    func initializePortal() {
        Task {
            do {
                // Initialize Portal SDK
                portal = try Portal(
                    clientAPIKey,
                    withRpcConfig: [
                        "eip155:10143" : "https://testnet-rpc.monad.xyz"
                    ],
                    autoApprove: true // keep it ``true`` to auto approve all the signing requests if needed.
                )

                // check if the Recover with password available or not
                isPasswordRecoverAvailable = try await self.portal?.availableRecoveryMethods().contains(.Password) ?? false

                // Update the UI that Portal Initialized
                setState(.portalInitialized(isRecoverAvailable: isPasswordRecoverAvailable))
                print("✅ Portal initialized.")
            } catch {
                setState(.error(errorMessage: "❌ Error initializing portal: \(error.localizedDescription)"))
                print("❌ Error initializing portal:", error.localizedDescription)
            }
        }
    }
}

// MARK: - Generate wallet
extension PortalWalletViewModel {
    /// Generate wallet to the user
    func generateWallet() {
        // early return if the portal is not initialized.
        guard let portal else {
            setState(.error(errorMessage: "❌ Portal not initialized, please call \"initializePortal()\" first."))
            print("❌ Portal not initialized, please call \"initializePortal()\" first.")
            return
        }

        // Update the UI show loader
        setState(.loading)

        Task {
            do {
                // create a the wallet
                let wallets = try await portal.createWallet()
                print("✅ wallet created successfully - Solana address: \(wallets.solana)")
                print("✅ wallet recovered successfully - ETH address: \(wallets.ethereum)")
                walletAddress = wallets.ethereum

                // get the balance for the wallet
                getBalance()
            } catch {
                setState(.portalInitialized(isRecoverAvailable: isPasswordRecoverAvailable))
                print("❌ Error generating wallet:", error.localizedDescription, "\n Maybe this Client API key has wallet already generated, if that is the case you may recover or provide new Client API Key to generate new wallet.")
            }
        }
    }
}

// MARK: - Get Balance
extension PortalWalletViewModel {
    /// Get the wallet balance and update the UI with the new fetched balances.
    func getBalance() {
        Task {
            if let assets = try? await getAssets() {
                self.assets = assets
                refreshWalletUI()
            } else {
                refreshWalletUI()
            }
        }
    }

    /// Get the assets for the user to get all the balances
    private func getAssets() async throws -> Assets {

        do {
            let assets = try await portal?.getAssets(chainId)
            let nativeBalance = assets?.nativeBalance?.balance // MON
            let USDCBalance = assets?.tokenBalances?.getBalance(for: "USDC")

            return Assets(
                nativeBalance: nativeBalance,
                USDCBalance: USDCBalance
            )
        } catch {
            print("❌ Unable to get assets with error: \(error)")
            throw error
        }
    }
}

struct Assets {
    let nativeBalance: String?
    let USDCBalance: String?
}

extension Array where Element == TokenBalanceResponse {
    /// Get the Balance for given symbol token.
    func getBalance(for symbol: String) -> String? {
        if let token = self.first(where: { $0.symbol == symbol }) {
            return token.balance
        } else {
            return nil
        }
    }
}

// MARK: - Transfer Tokens to another wallet
extension PortalWalletViewModel {
    /// Transfer  ``tokenSymbol`` with ``amount`` to ``recipient`` from the user wallet.
    func transfer(recipient: String, amount: String, tokenSymbol: String) {
        Task {
            // validate the recipient address is not empty.
            if !recipient.isEmpty {
                // Update the UI show loader
                setState(.loading)
                // build the send asset params
                let params = SendAssetParams(to: recipient, amount: amount, token: tokenSymbol)
                // send the asset
                await sendAsset(params: params)
            } else {
                // print error message if the input is not valid.
                print("❌ please enter valid address and amount in order to continue.")
            }
        }
    }

    /// Send asset given the ``SendAssetParams``.
    private func sendAsset(params: SendAssetParams) async {
        do {
            // send the asset given the ``chainId``.
            let response = try await portal?.sendAsset(chainId: chainId, params: params)
            if let hash = response?.txHash {
                // display the hash to the user
                transactionHash = hash
                refreshWalletUI()
                print("✅ Transaction Hash: \(hash)")
            }
        } catch {
            // refresh the UI to display the wallet data instead of the loader
            refreshWalletUI()
            print("❌ Unable to sign and send transaction with error: \(error)")
        }
    }
}

// MARK: - Backup Wallet
extension PortalWalletViewModel {
    func backupWallet(with password: String) {
        // early return if the portal is not initialized.
        guard let portal else {
            setState(.error(errorMessage: "❌ Portal not initialized, please call \"initializePortal()\" first."))
            print("❌ Portal not initialized, please call \"initializePortal()\" first.")
            return
        }

        Task {
            if !password.isEmpty {
                setState(.loading)

                do {
                    // set the password
                    try portal.setPassword(password)

                    // backup the wallet
                    _ = try await portal.backupWallet(.Password)

                    refreshWalletUI()
                    print("✅ Backup successfully.")
                } catch {
                    // refresh the UI to display the wallet data instead of the loader
                    refreshWalletUI()
                    print("❌ Unable to backup the wallet with error: \(error)")
                }
            } else {
                print("❌ please enter valid password to continue.")
            }
        }
    }
}

// MARK: - Recover Wallet
extension PortalWalletViewModel {
    func recoverWallet(with password: String) {
        // early return if the portal is not initialized.
        guard let portal else {
            setState(.error(errorMessage: "❌ Portal not initialized, please call \"initializePortal()\" first."))
            print("❌ Portal not initialized, please call \"initializePortal()\" first.")
            return
        }

        Task {
            if !password.isEmpty {
                setState(.loading)

                do {
                    // set the password
                    try portal.setPassword(password)

                    // recover the wallet
                    let wallets = try await portal.recoverWallet(.Password)

                    print("✅ wallet recovered successfully - Solana address: \(wallets.solana ?? "")")
                    print("✅ wallet recovered successfully - ETH address: \(wallets.ethereum)")
                    walletAddress = wallets.ethereum

                    // get the balance for the wallet
                    getBalance()
                } catch {
                    setState(.portalInitialized(isRecoverAvailable: isPasswordRecoverAvailable))
                    print("❌ Unable to recover the wallet with error: \(error)")
                }
            } else {
                print("❌ please enter valid password to continue.")
            }
        }
    }
}

// MARK: - Fund Testnet Wallet
extension PortalWalletViewModel {
    func fundTestnetWallet() {
        // early return if the portal is not initialized.
        guard let portal else {
            setState(.error(errorMessage: "❌ Portal not initialized, please call \"initializePortal()\" first."))
            print("❌ Portal not initialized, please call \"initializePortal()\" first.")
            return
        }

        Task {
            setState(.loading)

            do {
                // fund the wallet with test net asset
                _ = try await portal.receiveTestnetAsset(chainId: chainId, params: FundParams(amount: "0.01", token: "MON"))

                // get the balance for the wallet
                getBalance()
            } catch {
                // refresh the UI to display the wallet data instead of the loader
                refreshWalletUI()
                print("❌ Unable to fund the wallet with testnet asset with error: \(error)")
            }
        }
    }
}
