//
//  BotDashboardViewModel.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 6/26/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class BotDashboardViewModel: ObservableObject {
    @Published var botStatus: BotStatusResponse?
    @Published var trades: [Trade] = []
    @Published var isLoading = false
    @Published var isRunningBot = false
    @Published var errorMessage: String?
    @Published var lastRunResult: String?
    @Published var lastRefreshAt: Date?
    @Published var candles: [Candle] = []
    @Published var chartOverlay: ChartOverlay?
    @Published var activity: [ActivityItem] = []

    private let apiService = BotAPIService()
    private var isRefreshing = false

    func loadDashboard(showLoader: Bool = false) async {
        if isRefreshing {
            return
        }

        isRefreshing = true

        if showLoader {
            isLoading = true
        }

        errorMessage = nil

        defer {
            isLoading = false
            isRefreshing = false
        }

        do {
            async let status = apiService.fetchBotStatus()
            async let tradesResponse = apiService.fetchTrades()
            async let marketResponse = apiService.fetchMarketCandles()
            async let activityResponse = apiService.fetchActivity()

            let (statusResult, tradesResult, marketResult, activityResult) = try await (
                status,
                tradesResponse,
                marketResponse,
                activityResponse
            )

            botStatus = statusResult
            trades = tradesResult.trades
            candles = marketResult.candles
            chartOverlay = marketResult.chart
            activity = activityResult

            lastRefreshAt = Date()
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds
            ]

        } catch {
            errorMessage = error.localizedDescription
            print("Dashboard refresh failed: \(error.localizedDescription)")
        }
    }

    func runBotOnce() async {
        if isRunningBot {
            return
        }

        isRunningBot = true
        errorMessage = nil

        defer {
            isRunningBot = false
        }

        do {
            let response = try await apiService.runBotOnce()
            lastRunResult = response.result

            await loadDashboard(showLoader: false)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refreshFromForeground() async {
        await loadDashboard(showLoader: false)
    }
    
    func startBot() async {

        do {

            _ = try await apiService.startBot()

            await loadDashboard()

        } catch {

            errorMessage = error.localizedDescription

        }

    }

    func stopBot() async {

        do {

            _ = try await apiService.stopBot()

            await loadDashboard()

        } catch {

            errorMessage = error.localizedDescription

        }

    }
    
}

