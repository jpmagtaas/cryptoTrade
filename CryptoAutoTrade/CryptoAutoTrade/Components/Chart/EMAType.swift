//
//  EMAType.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/3/26.
//

import SwiftUI

enum EMAType {

    case ema20

    case ema50

    var color: Color {

        switch self {

        case .ema20:
            return .orange

        case .ema50:
            return .blue

        }

    }

    func value(for candle: Candle) -> Double {

        switch self {

        case .ema20:
            return candle.ema20

        case .ema50:
            return candle.ema50

        }

    }

}
