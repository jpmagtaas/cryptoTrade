//
//  CandleStickMark.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/2/26.
//

import SwiftUI
import Charts

struct CandlestickMark: ChartContent {

    let candle: Candle

    private var date: Date {
        Date(
            timeIntervalSince1970: Double(candle.timestamp) / 1000
        )
    }

    private var isBullish: Bool {
        candle.close >= candle.open
    }

    var body: some ChartContent {

        // Wick
        RuleMark(
            x: .value("Time", date),
            yStart: .value("Low", candle.low),
            yEnd: .value("High", candle.high)
        )
        .foregroundStyle(.gray)
        .lineStyle(
            StrokeStyle(lineWidth: 1)
        )

        // Body
        RectangleMark(
            x: .value("Time", date),
            yStart: .value("Body Low", min(candle.open, candle.close)),
            yEnd: .value("Body High", max(candle.open, candle.close)),
            width: 8
        )
        .foregroundStyle(
            isBullish ? .green : .red
        )
    }
}
