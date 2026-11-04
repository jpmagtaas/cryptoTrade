//
//  CurrentPriceOverlay.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/4/26.
//

import SwiftUI
import Charts

struct CurrentPriceOverlay: ChartContent {

    let candle: Candle

    var body: some ChartContent {

        RuleMark(
            y: .value(
                "Current Price",
                candle.close
            )
        )
        .foregroundStyle(
            candle.close >= candle.open
            ? .green
            : .red
        )
        .lineStyle(
            StrokeStyle(
                lineWidth: 1,
                dash: [5]
            )
        )

        PointMark(
            x: .value(
                "Time",
                Date(
                    timeIntervalSince1970:
                        Double(candle.timestamp) / 1000
                )
            ),
            y: .value(
                "Price",
                candle.close
            )
        )
        .annotation(position: .trailing) {

            Text(
                candle.close,
                format: .number.precision(.fractionLength(2))
            )
            .font(.caption)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                candle.close >= candle.open
                ? Color.green
                : Color.red
            )
            .foregroundStyle(.white)
            .clipShape(Capsule())

        }

    }

}
