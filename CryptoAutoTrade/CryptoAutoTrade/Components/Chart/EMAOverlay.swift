//
//  EMAOverlay.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/4/26.
//

import SwiftUI
import Charts

struct EMAOverlay: ChartContent {

    let candles: [Candle]

    var body: some ChartContent {

        ForEach(candles) { candle in

            LineMark(
                x: .value(
                    "Time",
                    Date(timeIntervalSince1970: Double(candle.timestamp) / 1000)
                ),
                y: .value(
                    "EMA",
                    candle.ema20
                )
            )
            .foregroundStyle(by: .value("Series", "EMA20"))
            .lineStyle(StrokeStyle(lineWidth: 2))

        }

        ForEach(candles) { candle in

            LineMark(
                x: .value(
                    "Time",
                    Date(timeIntervalSince1970: Double(candle.timestamp) / 1000)
                ),
                y: .value(
                    "EMA",
                    candle.ema50
                )
            )
            .foregroundStyle(by: .value("Series", "EMA50"))
            .lineStyle(StrokeStyle(lineWidth: 2))

        }

    }

}

