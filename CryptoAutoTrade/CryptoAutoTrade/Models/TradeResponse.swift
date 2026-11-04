//
//  TradeResponse.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 6/26/26.
//

import Foundation

struct TradesResponse: Decodable {
    let count: Int
    let trades: [Trade]
}

struct Trade: Decodable, Identifiable {
    let id: Int
    let symbol: String
    let side: String
    let entryPrice: Double
    let exitPrice: Double
    let quantity: Double
    let profit: Double
    let exitReason: String?
    let strategyName: String?
    let openedAt: String?
    let closedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case side
        case entryPrice = "entry_price"
        case exitPrice = "exit_price"
        case quantity
        case profit
        case exitReason = "exit_reason"
        case strategyName = "strategy_name"
        case openedAt = "opened_at"
        case closedAt = "closed_at"
    }
}

