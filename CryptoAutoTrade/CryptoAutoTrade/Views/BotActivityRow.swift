//
//  BotActivityRow.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/7/26.
//

import SwiftUI

struct BotActivityRow: View {

    let item: ActivityItem

    var body: some View {

        HStack(alignment: .top, spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 4) {

                Text(item.message)
                    .font(.subheadline)

                Text(relativeDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)

            }

            Spacer()

        }
        .padding(.vertical, 4)

    }

    private var icon: String {

        switch item.level {

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

        switch item.level {

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

    private var relativeDate: String {

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
