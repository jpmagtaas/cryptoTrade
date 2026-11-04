//
//  MarketResponse.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/1/26.
//

import Foundation

struct MarketResponse: Codable {

    let symbol: String
    let timeframe: String
    let count: Int
    let candles: [Candle]

    let chart: ChartOverlay

}

struct ChartOverlay: Codable {

    let breakoutLevel: Double?
    let breakoutTimestamp: Int?

    let entryPrice: Double?
    let stopLoss: Double?
    let takeProfit: Double?

    enum CodingKeys: String, CodingKey {

        case breakoutLevel = "breakout_level"
        case breakoutTimestamp = "breakout_timestamp"

        case entryPrice = "entry_price"
        case stopLoss = "stop_loss"
        case takeProfit = "take_profit"

    }

}
