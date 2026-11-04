//
//  BotActivityFeed.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/7/26.
//

import SwiftUI

struct BotActivityFeed: View {

    let activity: [ActivityItem]
    
    @State
    private var expanded = false

    private var displayedItems: [ActivityItem] {

        if expanded {
            return activity
        }

        return Array(activity.prefix(3))
    }
    
    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Bot Activity")
                .font(.headline)

            if activity.isEmpty {

                ContentUnavailableView(
                    "No Activity",
                    systemImage: "clock"
                )

            } else {

                LazyVStack(spacing: 0) {

                    ForEach(displayedItems) { item in

                        BotActivityRow(
                            item: item
                        )

                        Divider()

                    }

                }

                if activity.count > 3 {

                    Button {

                        withAnimation(.easeInOut) {
                            expanded.toggle()
                        }

                    } label: {

                        Text(
                            expanded
                            ? "Show Less"
                            : "Show \(activity.count - 3) More..."
                        )
                        .font(.footnote)

                    }

                }
                
            }

        }
        .padding()
        .background(.regularMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )

    }

}
