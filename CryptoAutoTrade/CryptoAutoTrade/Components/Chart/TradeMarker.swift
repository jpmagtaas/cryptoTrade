//
//  TradeMarker.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/3/26.
//

import SwiftUI
import Charts

struct TradeMarker: ChartContent {

    let trade: Trade

    private static let formatter = ISO8601DateFormatter()

    var body: some ChartContent {

        //
        // BUY
        //
        if let openedAt = trade.openedAt,
           let openDate = Self.tradeDateFormatter.date(from: openedAt) {

            PointMark(
                x: .value("Time", openDate),
                y: .value("Entry", trade.entryPrice)
            )
            .symbolSize(1)
            .annotation(position: .top) {

                VStack(spacing: 4) {

                    Image(systemName: "arrowtriangle.up.fill")
                        .font(.caption)
                        .foregroundStyle(.green)

                    Text("BUY")
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.green.opacity(0.15))
                        .foregroundStyle(.green)
                        .clipShape(Capsule())

                }

            }

        }

        //
        // SELL
        //
        if let closeDate = Self.tradeDateFormatter.date(from: trade.closedAt) {

            let isProfit = trade.profit >= 0

            PointMark(
                x: .value("Time", closeDate),
                y: .value("Exit", trade.exitPrice)
            )
            .symbolSize(1)
            .annotation(position: .bottom) {

                VStack(spacing: 4) {

                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundStyle(
                            isProfit ? .green : .red
                        )

                    Text("SELL")
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            (isProfit ? Color.green : Color.red)
                                .opacity(0.15)
                        )
                        .foregroundStyle(
                            isProfit ? .green : .red
                        )
                        .clipShape(Capsule())

                    Text(
                        trade.profit,
                        format: .currency(code: "USD")
                    )
                    .font(.caption2)
                    .foregroundStyle(
                        isProfit ? .green : .red
                    )

                }

            }

        }

    }

    private func parseISODate(_ value: String) -> Date? {

        let normalized = value.replacingOccurrences(
            of: #"(\.\d{3})\d+"#,
            with: "$1",
            options: .regularExpression
        )

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        return formatter.date(from: normalized)
    }
    
    private static let tradeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()
}
