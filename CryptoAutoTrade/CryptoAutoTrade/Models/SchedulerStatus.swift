//
//  SchedulerStatus.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 6/26/26.
//

import Foundation

struct SchedulerStatus: Codable {

    let running: Bool

    let intervalSeconds: Int

    enum CodingKeys: String, CodingKey {

        case running

        case intervalSeconds = "interval_seconds"

    }

}
