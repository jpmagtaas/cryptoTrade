//
//  MarketChartView.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/1/26.
//

import SwiftUI
import Charts

struct MarketChartView: View {

    let title: String
    let candles: [Candle]
    let trades: [Trade]
    let openPosition: OpenPosition?
    let chartOverlay: ChartOverlay?

    private var minPrice: Double {

        var values = candles.flatMap { [$0.low, $0.high] }

        if let position = openPosition {

            values.append(position.entryPrice)
            values.append(position.stopLoss)
            values.append(position.takeProfit)

        }

        guard let min = values.min() else {
            return 0
        }

        return min * 0.995
    }

    private var maxPrice: Double {

        var values = candles.flatMap { [$0.low, $0.high] }

        if let position = openPosition {

            values.append(position.entryPrice)
            values.append(position.stopLoss)
            values.append(position.takeProfit)

        }

        guard let max = values.max() else {
            return 1
        }

        return max * 1.005
    }
    
    private var xDomain: ClosedRange<Date> {

        guard
            let first = candles.first,
            let last = candles.last
        else {
            let now = Date()
            return now...now
        }

        return Date(timeIntervalSince1970: Double(first.timestamp) / 1000)...Date(timeIntervalSince1970: Double(last.timestamp) / 1000)
    }
    
    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text(title)
                .font(.headline)
            
            Chart {

                ForEach(candles) { candle in

                    CandlestickMark(
                        candle: candle
                    )

                }
                
                ForEach(trades) { trade in

                    TradeMarker(
                        trade: trade
                    )

                }

                if let position = openPosition {

                    OpenPositionOverlay(
                        position: position
                    )

                }
                
                if let chartOverlay {
                    BreakoutOverlay(
                        candles: candles,
                        chart: chartOverlay
                    )
                }
                
//                EMAOverlay(
//                    candles: candles
//                )
                
                ForEach(candles) { candle in

                    LineMark(
                        x: .value(
                            "Time",
                            Date(timeIntervalSince1970: Double(candle.timestamp) / 1000)
                        ),
                        y: .value(
                            "EMA",
                            candle.ema20
                        )
                    )
                    .foregroundStyle(by: .value("Series", "EMA20"))
                    .lineStyle(StrokeStyle(lineWidth: 2))

                }

                ForEach(candles) { candle in

                    LineMark(
                        x: .value(
                            "Time",
                            Date(timeIntervalSince1970: Double(candle.timestamp) / 1000)
                        ),
                        y: .value(
                            "EMA",
                            candle.ema50
                        )
                    )
                    .foregroundStyle(by: .value("Series", "EMA50"))
                    .lineStyle(StrokeStyle(lineWidth: 2))

                }
                
                if let last = candles.last {

                    CurrentPriceOverlay(
                        candle: last
                    )

                }

            }
            .frame(height: 320)
            .chartPlotStyle { plotArea in
                plotArea
                    .padding(.top, 12)
            }
            //.clipped()
            .chartXScale(domain: xDomain)
            .chartYScale(
                domain: minPrice...maxPrice
            )
            
            // Hide vertical grid lines
            .chartXAxis {

                AxisMarks(values: .automatic(desiredCount: 6)) { value in

                    AxisGridLine()

                    AxisTick()

                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())

                }

            }
            // Better price labels
            .chartYAxis {

                AxisMarks(position: .trailing) { value in

                    AxisGridLine()

                    AxisTick()

                    AxisValueLabel()

                }

            }
            .chartLegend(.hidden)
            .chartForegroundStyleScale([
                "EMA20": Color.orange,
                "EMA50": Color.blue
            ])
            
            if let openPosition,
               let currentPrice = candles.last?.close {

                LivePositionCard(
                    position: openPosition,
                    currentPrice: currentPrice
                )
                .padding(.top)

            }
        }
        
    }

}

