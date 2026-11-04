//
//  BreakoutOverlay.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/4/26.
//

import SwiftUI
import Charts

struct BreakoutOverlay: ChartContent {

    let candles: [Candle]
    let chart: ChartOverlay

    var body: some ChartContent {

        if let breakoutLevel = chart.breakoutLevel {

            //
            // Horizontal resistance line
            //

            RuleMark(
                y: .value(
                    "Resistance",
                    breakoutLevel
                )
            )
            .foregroundStyle(.cyan)
            .lineStyle(
                StrokeStyle(
                    lineWidth: 1.5,
                    dash: [8]
                )
            )
            .annotation(position: .leading) {

                Text("Resistance")
                    .font(.caption2)
                    .foregroundStyle(.cyan)

            }

        }

        if
            let breakoutTimestamp = chart.breakoutTimestamp,
            let breakoutLevel = chart.breakoutLevel,
            let candle = candles.first(
                where: {
                    $0.timestamp == breakoutTimestamp
                }
            ) {

            //
            // Breakout marker
            //

            PointMark(

                x: .value(
                    "Time",
                    Date(
                        timeIntervalSince1970:
                            Double(candle.timestamp) / 1000
                    )
                ),

                y: .value(
                    "Breakout",
                    breakoutLevel
                )

            )
            .symbol(.circle)
            .symbolSize(90)
            .foregroundStyle(.green)

            .annotation(position: .top) {

                VStack(spacing: 2) {

                    Image(systemName: "arrow.up")

                    Text("Breakout")
                        .font(.caption2.bold())

                }
                .foregroundStyle(.green)

            }

        }

    }

}
