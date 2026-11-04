//
//  CandleBodyLayer.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/2/26.
//

import SwiftUI
import Charts

struct CandleBodyLayer: ChartContent {

    let candles: [Candle]

    var body: some ChartContent {

        ForEach(candles) { candle in

            RectangleMark(

                x: .value(
                    "Time",
                    Date(
                        timeIntervalSince1970:
                            Double(candle.timestamp) / 1000
                    )
                ),

                yStart: .value(
                    "Open",
                    candle.open
                ),

                yEnd: .value(
                    "Close",
                    candle.close
                ),

                width: 8
            )
            .foregroundStyle(
                candle.close >= candle.open
                ? .green
                : .red
            )
        }
    }
}
