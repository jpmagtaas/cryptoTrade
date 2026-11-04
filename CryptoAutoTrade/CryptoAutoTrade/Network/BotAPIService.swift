//
//  BotAPIService.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 6/26/26.
//

import Foundation

final class BotAPIService {

    //private let baseURL = "http://127.0.0.1:8000"
    private let baseURL = "http://192.168.1.15:8000"

    // MARK: - Generic Requests

    private func get<T: Decodable>(
        _ endpoint: String
    ) async throws -> T {

        let url = URL(
            string: "\(baseURL)\(endpoint)"
        )!

        let (data, _) = try await URLSession.shared.data(
            from: url
        )

        let decoder = JSONDecoder()

        return try decoder.decode(
            T.self,
            from: data
        )

    }

    private func post<T: Decodable>(
        _ endpoint: String
    ) async throws -> T {

        let url = URL(
            string: "\(baseURL)\(endpoint)"
        )!

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        let (data, _) = try await URLSession.shared.data(
            for: request
        )

        let decoder = JSONDecoder()

        return try decoder.decode(
            T.self,
            from: data
        )

    }
    
    private func post<Request: Encodable, Response: Decodable>(
        _ endpoint: String,
        body: Request
    ) async throws -> Response {

        let url = URL(
            string: "\(baseURL)\(endpoint)"
        )!

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.httpBody = try JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(
            for: request
        )

        print("POST \(endpoint)")
        print(String(data: data, encoding: .utf8) ?? "Unable to decode response")

        let decoder = JSONDecoder()

        return try decoder.decode(
            Response.self,
            from: data
        )
    }

    // MARK: - Bot

    func fetchBotStatus() async throws -> BotStatusResponse {

        try await get("/bot/status")

    }

    func runBotOnce() async throws -> RunBotResponse {

        try await post("/bot/run-once")

    }

    func startBot() async throws -> SchedulerResponse {

        try await post("/bot/start")

    }

    func stopBot() async throws -> SchedulerResponse {

        try await post("/bot/stop")

    }

    // MARK: - Market

    func fetchMarketCandles() async throws -> MarketResponse {

        try await get("/market/candles")

    }

    // MARK: - Trades

    func fetchTrades() async throws -> TradesResponse {

        try await get("/trades")

    }
    
    func fetchTrade(
        id: Int
    ) async throws -> TradeDetailsResponse {

        try await get("/trades/\(id)")

    }

    // MARK: - Activity

    func fetchActivity() async throws -> [ActivityItem] {

        try await get("/activity")

    }

    // MARK: - Config
    
    func fetchConfig() async throws -> BotConfigResponse {

        try await get("/config")

    }
    
    func updateConfig(
        _ config: BotConfigResponse
    ) async throws -> BotConfigResponse {

        let request = UpdateBotConfigRequest(
            symbol: config.symbol,
            timeframe: config.timeframe,
            strategyName: config.strategyName,

            riskPerTrade: config.riskPerTrade,
            stopLossPercent: config.stopLossPercent,
            takeProfitPercent: config.takeProfitPercent,

            tradingFee: config.tradingFee,

            breakoutLookback: config.breakoutLookback,
            volumeLookback: config.volumeLookback,

            breakoutBuffer: config.breakoutBuffer,
            volumeMultiplier: config.volumeMultiplier
        )

        return try await post(
            "/config",
            body: request
        )
    }
    
}

struct RunBotResponse: Decodable {

    let message: String
    let result: String

}
