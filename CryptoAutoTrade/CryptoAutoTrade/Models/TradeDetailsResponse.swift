//
//  TradeDetailsResponse.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/30/26.
//

import Foundation

struct TradeDetailsResponse: Decodable {

    let trade: Trade
    let market: MarketResponse

}
