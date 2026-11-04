//
//  OpenPositionOverlay.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/3/26.
//

import SwiftUI
import Charts

struct OpenPositionOverlay: ChartContent {

    let position: OpenPosition

    var body: some ChartContent {

        RuleMark(
            y: .value(
                "Entry",
                position.entryPrice
            )
        )
        .foregroundStyle(.yellow)
        .lineStyle(
            StrokeStyle(
                lineWidth: 2
            )
        )
        .annotation(position: .trailing) {

            Text("ENTRY")
                .font(.caption2.bold())
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.yellow.opacity(0.2))
                .clipShape(Capsule())

        }

        RuleMark(
            y: .value(
                "Stop Loss",
                position.stopLoss
            )
        )
        .foregroundStyle(.red)
        .lineStyle(
            StrokeStyle(
                lineWidth: 2,
                dash: [6]
            )
        )
        .annotation(position: .trailing) {

            Text("SL")
                .font(.caption2.bold())
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.red.opacity(0.2))
                .clipShape(Capsule())

        }

        RuleMark(
            y: .value(
                "Take Profit",
                position.takeProfit
            )
        )
        .foregroundStyle(.green)
        .lineStyle(
            StrokeStyle(
                lineWidth: 2,
                dash: [6]
            )
        )
        .annotation(position: .trailing) {

            Text("TP")
                .font(.caption2.bold())
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.green.opacity(0.2))
                .clipShape(Capsule())

        }

    }

}
