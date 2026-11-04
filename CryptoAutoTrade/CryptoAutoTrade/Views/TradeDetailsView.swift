//
//  TradeDetailsView.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/7/26.
//

import SwiftUI

struct TradeDetailsView: View {

    let tradeId: Int

    @StateObject
    private var viewModel = TradeDetailsViewModel()

    var body: some View {

        Group {

            if viewModel.isLoading {

                ProgressView()

            } else if let response = viewModel.response {

                let trade = response.trade
                
                List {

                    MarketChartView(
                        title: "\(trade.symbol) Chart",
                        candles: response.market.candles,
                        trades: [],
                        openPosition: nil,
                        chartOverlay: nil
                    )
                    .listRowInsets(
                        EdgeInsets()
                    )
                    
                    LabeledContent(
                        "Symbol",
                        value: trade.symbol
                    )

                    LabeledContent(
                        "Side",
                        value: trade.side
                    )

                    LabeledContent(
                        "Entry",
                        value: String(format: "%.2f", trade.entryPrice)
                    )

                    LabeledContent(
                        "Exit",
                        value: String(format: "%.2f", trade.exitPrice)
                    )

                    LabeledContent(
                        "Profit",
                        value: String(format: "%.2f", trade.profit)
                    )

                    LabeledContent(
                        "Strategy",
                        value: trade.strategyName ?? "-"
                    )

                    LabeledContent(
                        "Exit Reason",
                        value: trade.exitReason ?? "-"
                    )

                }

            } else {

                ContentUnavailableView(
                    "Trade not found",
                    systemImage: "xmark.circle"
                )

            }

        }
        .navigationTitle("Trade Details")
        .task {

            await viewModel.loadTrade(
                id: tradeId
            )

        }

    }

}
