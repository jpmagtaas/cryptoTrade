//
//  StrategyStatusCard.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/4/26.
//

import SwiftUI

struct StrategyStatusCard: View {

    let strategy: StrategyStatus

    private var statusColor: Color {

        switch strategy.status {

        case "BUY":
            return .green

        case "SELL":
            return .red

        default:
            return .orange

        }

    }

    private var confidencePercent: Int {
        Int(strategy.confidence * 100)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text("Strategy")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(strategy.name.capitalized)
                        .font(.title3.bold())

                }

                Spacer()

                Text(strategy.status)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.15))
                    .foregroundStyle(statusColor)
                    .clipShape(Capsule())

            }

            VStack(alignment: .leading, spacing: 6) {

                Text("Reason")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(strategy.reason)

            }

            VStack(alignment: .leading, spacing: 8) {

                HStack {

                    Text("Confidence")

                    Spacer()

                    Text("\(confidencePercent)%")
                        .bold()

                }

                ProgressView(value: strategy.confidence)
                    .tint(statusColor)

            }

            Divider()

            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {

                GridRow {

                    Text("Current")

                    Spacer()

                    Text(strategy.currentPrice,
                         format: .number.precision(.fractionLength(2)))

                }

                GridRow {

                    Text("Breakout")

                    Spacer()

                    if let breakout = strategy.breakoutLevel {

                        Text(
                            breakout,
                            format: .number.precision(.fractionLength(2))
                        )

                    } else {

                        Text("--")

                    }

                }

                GridRow {

                    Text("Distance")

                    Spacer()

                    if let distance = strategy.distancePercent {

                        Text(
                            "\(distance.formatted(.number.precision(.fractionLength(2))))%"
                        )
                        .foregroundStyle(
                            distance >= 0
                            ? .green
                            : .orange
                        )

                    } else {

                        Text("--")

                    }

                }

                GridRow {

                    Text("Volume")

                    Spacer()

                    Label(
                        strategy.volumeConfirmed
                        ? "Confirmed"
                        : "Waiting",
                        systemImage: strategy.volumeConfirmed
                        ? "checkmark.circle.fill"
                        : "clock"
                    )
                    .foregroundStyle(
                        strategy.volumeConfirmed
                        ? .green
                        : .orange
                    )

                }

            }

        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
        .shadow(radius: 2)

    }

}
