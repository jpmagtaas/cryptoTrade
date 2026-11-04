//
//  LivePositionCard.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/4/26.
//

import SwiftUI

struct LivePositionCard: View {

    let position: OpenPosition
    let currentPrice: Double

    private var pnlPercent: Double {

        ((currentPrice - position.entryPrice) / position.entryPrice) * 100

    }

    private var pnlAmount: Double {

        (currentPrice - position.entryPrice) * position.quantity

    }

    private var isProfit: Bool {

        currentPrice >= position.entryPrice

    }

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            HStack {

                Label(
                    "LIVE POSITION",
                    systemImage: "chart.line.uptrend.xyaxis"
                )
                .font(.headline)

                Spacer()

                Text(isProfit ? "PROFIT" : "LOSS")
                    .font(.caption.bold())
                    .foregroundStyle(isProfit ? .green : .red)

            }

            Divider()

            infoRow(
                title: "Entry",
                value: position.entryPrice
            )

            infoRow(
                title: "Current",
                value: currentPrice
            )

            Divider()

            HStack {

                VStack(alignment: .leading) {

                    Text("P/L")

                    Text(
                        pnlAmount,
                        format: .currency(code: "USD")
                    )
                    .font(.title3.bold())
                    .foregroundStyle(
                        isProfit
                        ? .green
                        : .red
                    )

                }

                Spacer()

                Text(
                    "\(pnlPercent, specifier: "%.2f")%"
                )
                .font(.title2.bold())
                .foregroundStyle(
                    isProfit
                    ? .green
                    : .red
                )

            }

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )

    }

    @ViewBuilder
    private func infoRow(
        title: String,
        value: Double
    ) -> some View {

        HStack {

            Text(title)

            Spacer()

            Text(
                value,
                format: .number.precision(.fractionLength(2))
            )
            .monospacedDigit()

        }

    }

}
