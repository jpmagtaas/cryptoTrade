//
//  TradeDetailsViewModel.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/7/26.
//

import Foundation
import Combine

@MainActor
final class TradeDetailsViewModel: ObservableObject {

    @Published var response: TradeDetailsResponse?

    @Published var isLoading = false

    @Published var errorMessage: String?

    private let api = BotAPIService()

    func loadTrade(
        id: Int
    ) async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            response = try await api.fetchTrade(
                id: id
            )

        } catch {

            errorMessage = error.localizedDescription

        }

    }

}
