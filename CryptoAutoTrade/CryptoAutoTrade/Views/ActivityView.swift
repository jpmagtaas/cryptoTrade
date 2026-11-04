//
//  ActivityView.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/7/26.
//

import SwiftUI

struct ActivityView: View {

    let activity: [ActivityItem]

    var body: some View {

        List {

            ForEach(activity) { item in

                BotActivityRow(
                    item: item
                )

            }

        }
        .navigationTitle("Activity")

    }

}
