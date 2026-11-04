//
//  DateParser.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/7/26.
//

import Foundation

private let activityFormatter: ISO8601DateFormatter = {

    let formatter = ISO8601DateFormatter()

    formatter.formatOptions = [
        .withInternetDateTime
    ]

    return formatter

}()

func parseISODate(
    _ value: String
) -> Date? {

    activityFormatter.date(from: value)

}
