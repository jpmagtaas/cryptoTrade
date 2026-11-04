//
//  CandleWickLayer.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/2/26.
//

import SwiftUI
import Charts

struct CandleWickLayer: ChartContent {

    let candles: [Candle]

    var body: some ChartContent {

        ForEach(candles) { candle in

            RuleMark(

                x: .value(
                    "Time",
                    Date(
                        timeIntervalSince1970:
                            Double(candle.timestamp) / 1000
                    )
                ),

                yStart: .value(
                    "Low",
                    candle.low
                ),

                yEnd: .value(
                    "High",
                    candle.high
                )
            )
        }
    }
}
