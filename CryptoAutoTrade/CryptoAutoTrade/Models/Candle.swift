//
//  Candle.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/1/26.
//

import Foundation

import Foundation

struct Candle: Codable, Identifiable {

    var id: Int { timestamp }

    let timestamp: Int

    let open: Double
    let high: Double
    let low: Double
    let close: Double

    let volume: Double

    let ema20: Double
    let ema50: Double

    let breakoutLevel: Double?
    let isBreakout: Bool

    enum CodingKeys: String, CodingKey {

        case timestamp

        case open
        case high
        case low
        case close

        case volume

        case ema20
        case ema50

        case breakoutLevel = "breakout_level"
        case isBreakout = "is_breakout"

    }

}
