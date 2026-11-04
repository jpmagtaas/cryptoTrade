//
//  BotConfigResponse.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/30/26.
//

import Foundation

struct BotConfigResponse: Codable {

    var symbol: String
    var timeframe: String
    var strategyName: String

    var startingBalance: Double

    var riskPerTrade: Double
    var stopLossPercent: Double
    var takeProfitPercent: Double

    var tradingFee: Double

    var breakoutLookback: Int
    var volumeLookback: Int

    var breakoutBuffer: Double
    var volumeMultiplier: Double

    enum CodingKeys: String, CodingKey {

        case symbol
        case timeframe

        case strategyName = "strategy_name"

        case startingBalance = "starting_balance"

        case riskPerTrade = "risk_per_trade"
        case stopLossPercent = "stop_loss_percent"
        case takeProfitPercent = "take_profit_percent"

        case tradingFee = "trading_fee"

        case breakoutLookback = "breakout_lookback"
        case volumeLookback = "volume_lookback"

        case breakoutBuffer = "breakout_buffer"
        case volumeMultiplier = "volume_multiplier"

    }

}

struct UpdateBotConfigRequest: Encodable {

    let symbol: String
    let timeframe: String
    let strategyName: String

    let riskPerTrade: Double
    let stopLossPercent: Double
    let takeProfitPercent: Double

    let tradingFee: Double

    let breakoutLookback: Int
    let volumeLookback: Int

    let breakoutBuffer: Double
    let volumeMultiplier: Double

    enum CodingKeys: String, CodingKey {
        case symbol
        case timeframe
        case strategyName = "strategy_name"

        case riskPerTrade = "risk_per_trade"
        case stopLossPercent = "stop_loss_percent"
        case takeProfitPercent = "take_profit_percent"

        case tradingFee = "trading_fee"

        case breakoutLookback = "breakout_lookback"
        case volumeLookback = "volume_lookback"

        case breakoutBuffer = "breakout_buffer"
        case volumeMultiplier = "volume_multiplier"
    }
}
