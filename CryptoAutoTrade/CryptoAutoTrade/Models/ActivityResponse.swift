//
//  ActivityResponse.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/7/26.
//

import Foundation

struct ActivityItem: Codable, Identifiable {

    let id: Int
    let timestamp: String
    let level: String
    let message: String

}
