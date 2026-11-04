//
//  BotStatusResponse.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 6/26/26.
//

import Foundation

struct BotStatusResponse: Decodable {

    let botName: String
    let strategy: String
    let symbol: String

    let hasOpenPosition: Bool
    let openPosition: OpenPosition?

    let wallet: Wallet

    let botState: BotState
    
    let strategyStatus: StrategyStatus

    let scheduler: SchedulerStatus
    
    enum CodingKeys: String, CodingKey {
        case botName = "bot_name"
        case strategy
        case symbol

        case hasOpenPosition = "has_open_position"
        case openPosition = "open_position"

        case wallet

        case botState = "bot_state"
        
        case strategyStatus = "strategy_status"

        case scheduler
    }
}

struct Wallet: Decodable {
    let id: Int
    let startingBalance: Double
    let currentBalance: Double

    enum CodingKeys: String, CodingKey {
        case id
        case startingBalance = "starting_balance"
        case currentBalance = "current_balance"
    }
}

struct BotState: Decodable {
    let id: Int
    let lastRunAt: String?
    let lastAction: String?
    let lastPrice: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case lastRunAt = "last_run_at"
        case lastAction = "last_action"
        case lastPrice = "last_price"
    }
}

struct OpenPosition: Decodable {
    let id: Int
    let symbol: String
    let entryPrice: Double
    let quantity: Double
    let stopLoss: Double
    let takeProfit: Double
    let strategyName: String?
    let openedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case entryPrice = "entry_price"
        case quantity
        case stopLoss = "stop_loss"
        case takeProfit = "take_profit"
        case strategyName = "strategy_name"
        case openedAt = "opened_at"
    }
}

struct StrategyStatus: Decodable {

    let name: String

    let status: String

    let confidence: Double

    let reason: String

    let currentPrice: Double

    let breakoutLevel: Double?

    let distancePercent: Double?

    let volumeConfirmed: Bool

    enum CodingKeys: String, CodingKey {

        case name
        case status
        case confidence
        case reason

        case currentPrice = "current_price"

        case breakoutLevel = "breakout_level"

        case distancePercent = "distance_percent"

        case volumeConfirmed = "volume_confirmed"

    }

}
