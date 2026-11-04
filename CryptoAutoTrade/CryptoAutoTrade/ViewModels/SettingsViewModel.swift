//
//  SettingsViewModel.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/30/26.
//

import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var config: BotConfigResponse?

    @Published var isLoading = false

    @Published var errorMessage: String?

    private let api = BotAPIService()

    func load() async {

        isLoading = true

        defer {

            isLoading = false

        }

        do {

            config = try await api.fetchConfig()

        } catch {

            errorMessage = error.localizedDescription

        }

    }
    
    func save(_ config: BotConfigResponse) async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            self.config = try await api.updateConfig(config)

        } catch let DecodingError.keyNotFound(key, context) {

            errorMessage = "Missing key: \(key.stringValue)"

            print("Missing key:", key.stringValue)
            print("Coding path:", context.codingPath)

        } catch {

            errorMessage = error.localizedDescription
            print("Save config failed:", error)
        }
    }

    func validate(_ config: BotConfigResponse) -> String? {

        if config.riskPerTrade <= 0 || config.riskPerTrade > 1 {
            return "Risk per trade must be between 0% and 100%."
        }

        if config.stopLossPercent <= 0 || config.stopLossPercent >= 1 {
            return "Stop loss must be between 0% and 100%."
        }

        if config.takeProfitPercent <= 0 {
            return "Take profit must be greater than 0%."
        }

        if config.tradingFee < 0 || config.tradingFee >= 1 {
            return "Trading fee must be between 0% and 100%."
        }
        
        if config.breakoutLookback < 2 {
            return "Breakout lookback must be at least 2."
        }

        if config.volumeLookback < 2 {
            return "Volume lookback must be at least 2."
        }

        if config.breakoutBuffer <= 1 {
            return "Breakout buffer must be greater than 1."
        }

        if config.volumeMultiplier <= 0 {
            return "Volume multiplier must be greater than 0."
        }

        return nil
    }
}
