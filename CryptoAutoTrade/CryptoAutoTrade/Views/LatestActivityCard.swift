//
//  LatestActivityCard.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/7/26.
//

import SwiftUI

struct LatestActivityCard: View {

    let latest: ActivityItem?

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 4) {

                Text("Latest Activity")
                    .font(.headline)

                if let latest {

                    Text(latest.message)
                        .font(.subheadline)
                        .foregroundStyle(.primary)

                    Text(relativeDate(for: latest))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                } else {

                    Text("No activity yet")
                        .foregroundStyle(.secondary)

                }

            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)

        }
        .padding()
        .background(.regularMaterial)

    }

    private var icon: String {

        guard let latest else {
            return "clock"
        }

        switch latest.level {

        case "SUCCESS":
            return "checkmark.circle.fill"

        case "WARNING":
            return "exclamationmark.triangle.fill"

        case "ERROR":
            return "xmark.circle.fill"

        default:
            return "info.circle.fill"

        }

    }

    private var color: Color {

        guard let latest else {
            return .secondary
        }

        switch latest.level {

        case "SUCCESS":
            return .green

        case "WARNING":
            return .orange

        case "ERROR":
            return .red

        default:
            return .blue

        }

    }

    private func relativeDate(
        for item: ActivityItem
    ) -> String {

        guard let date = parseISODate(item.timestamp) else {
            return item.timestamp
        }

        return date.formatted(
            .relative(
                presentation: .named
            )
        )

    }

}
