//
//  BotDashboardView.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 6/26/26.
//

import SwiftUI
import Combine

struct BotDashboardView: View {
    @StateObject private var viewModel = BotDashboardViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.botStatus == nil {
                    ProgressView("Loading bot dashboard...")
                } else if let error = viewModel.errorMessage, viewModel.botStatus == nil {
                    VStack(spacing: 12) {
                        Text("Failed to load dashboard")
                            .font(.headline)

                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        Button("Retry") {
                            Task {
                                await viewModel.loadDashboard(showLoader: true)
                            }
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            if let botStatus = viewModel.botStatus {
                                headerSection(botStatus)
                                
                                if let strategy = viewModel.botStatus?.strategyStatus {

                                    StrategyStatusCard(
                                        strategy: strategy
                                    )

                                }
                                
                                MarketChartView(
                                    title: botStatus.symbol,
                                    candles: viewModel.candles,
                                    trades: viewModel.trades,
                                    openPosition: viewModel.botStatus?.openPosition,
                                    chartOverlay: viewModel.chartOverlay
                                )
                                
                                NavigationLink {

                                    ActivityView(
                                        activity: viewModel.activity
                                    )

                                } label: {

                                    LatestActivityCard(
                                        latest: viewModel.activity.first
                                    )

                                }
                                
                                summarySection(botStatus)
                                walletSection(botStatus.wallet)
                                
                                schedulerSection(
                                    botStatus.scheduler
                                )
                                
                                botStateSection(botStatus.botState)
                                openPositionSection(botStatus.openPosition)
                            }

                            refreshInfoSection()

                            if let result = viewModel.lastRunResult {
                                runResultSection(result)
                            }

                            recentTradesSection(viewModel.trades)
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.loadDashboard(showLoader: false)
                    }
                }
            }
            .navigationTitle("Crypto Bot")
            .toolbar {
                ToolbarItemGroup(
                    placement: .navigationBarTrailing
                ) {

                    Button("Start") {
                        Task {
                            await viewModel.startBot()
                        }
                    }

                    Button("Stop") {
                        Task {
                            await viewModel.stopBot()
                        }
                    }

                    Button("Run") {
                        Task {
                            await viewModel.runBotOnce()
                        }
                    }

                }
                
                ToolbarItem(placement: .topBarTrailing) {

                    NavigationLink {

                        SettingsView()

                    } label: {

                        Image(systemName: "gearshape")

                    }

                }
            }
            .task {
                await viewModel.loadDashboard(showLoader: true)
            }
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(10))
                    await viewModel.loadDashboard(showLoader: false)
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    Task {
                        await viewModel.refreshFromForeground()
                    }
                }
            }
        }
    }

    private func headerSection(_ botStatus: BotStatusResponse) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(botStatus.botName)
                .font(.title2.bold())

            HStack {
                Label(botStatus.strategy.capitalized, systemImage: "waveform.path.ecg")
                Spacer()
                Label(botStatus.symbol, systemImage: "bitcoinsign.circle")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func summarySection(_ botStatus: BotStatusResponse) -> some View {
        let currentBalance = botStatus.wallet.currentBalance
        let startingBalance = botStatus.wallet.startingBalance
        let pnl = currentBalance - startingBalance

        return VStack(alignment: .leading, spacing: 12) {
            Text("Summary")
                .font(.headline)

            HStack(spacing: 16) {
                summaryMetric(
                    title: "Balance",
                    value: currency(currentBalance),
                    color: .primary
                )

                summaryMetric(
                    title: "PnL",
                    value: pnl >= 0 ? "+\(currency(pnl))" : currency(pnl),
                    color: pnl >= 0 ? .green : .red
                )

                summaryMetric(
                    title: "Position",
                    value: botStatus.hasOpenPosition ? "OPEN" : "NONE",
                    color: botStatus.hasOpenPosition ? .orange : .secondary
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func summaryMetric(
        title: String,
        value: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func walletSection(_ wallet: Wallet) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Wallet")
                .font(.headline)

            HStack {
                VStack(alignment: .leading) {
                    Text("Starting Balance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(currency(wallet.startingBalance))
                        .font(.title3.bold())
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Current Balance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(currency(wallet.currentBalance))
                        .font(.title3.bold())
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func botStateSection(_ botState: BotState) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bot State")
                .font(.headline)

            row("Last Action", botState.lastAction ?? "-")
            row("Last Price", botState.lastPrice.map { currency($0) } ?? "-")
            row("Last Run", formatDate(botState.lastRunAt))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    @ViewBuilder
    private func openPositionSection(_ position: OpenPosition?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Open Position")
                .font(.headline)

            if let position {
                row("Symbol", position.symbol)
                row("Entry Price", currency(position.entryPrice))
                row("Quantity", String(format: "%.6f", position.quantity))
                row("Stop Loss", currency(position.stopLoss))
                row("Take Profit", currency(position.takeProfit))
                row("Strategy", position.strategyName ?? "-")
                row("Opened At", formatDate(position.openedAt))
            } else {
                Text("No open position")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func refreshInfoSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Refresh Info")
                .font(.headline)

            row(
                "Last Refresh",
                formatRefreshDate(viewModel.lastRefreshAt)
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func runResultSection(_ result: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Last Manual Run")
                .font(.headline)

            Text(result)
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func recentTradesSection(_ trades: [Trade]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Trades")
                .font(.headline)

            if trades.isEmpty {
                Text("No trades yet")
                    .foregroundColor(.secondary)
            } else {
                ForEach(trades) { trade in

                    NavigationLink {

                        TradeDetailsView(
                            tradeId: trade.id
                        )

                    } label: {

                        VStack(alignment: .leading, spacing: 6) {

                            HStack {

                                Text(trade.symbol)
                                    .font(.subheadline.bold())

                                Spacer()

                                Text(currency(trade.profit))
                                    .foregroundColor(
                                        trade.profit >= 0
                                        ? .green
                                        : .red
                                    )
                                    .font(.subheadline.bold())

                            }

                            row(
                                "Entry",
                                currency(trade.entryPrice)
                            )

                            row(
                                "Exit",
                                currency(trade.exitPrice)
                            )

                            row(
                                "Qty",
                                String(
                                    format: "%.6f",
                                    trade.quantity
                                )
                            )

                            row(
                                "Exit Reason",
                                trade.exitReason ?? "-"
                            )

                            row(
                                "Strategy",
                                trade.strategyName ?? "-"
                            )

                            row(
                                "Closed At",
                                formatDate(trade.closedAt)
                            )

                        }
                        .padding(.vertical, 8)

                    }
                    .buttonStyle(.plain)

                    Divider()

                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func schedulerSection(
        _ scheduler: SchedulerStatus
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Scheduler")
                .font(.headline)

            HStack {

                Circle()
                    .fill(
                        scheduler.running
                        ? .green
                        : .red
                    )
                    .frame(width: 12, height: 12)

                Text(
                    scheduler.running
                    ? "Running"
                    : "Stopped"
                )

                Spacer()

                Text(
                    "\(scheduler.intervalSeconds)s"
                )
                .foregroundColor(.secondary)

            }

        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            Color(.secondarySystemBackground)
        )
        .cornerRadius(12)
    }
    
    private func row(_ title: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }

    private func currency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func formatDate(_ raw: String?) -> String {
        guard let raw else { return "-" }

        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: raw) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }

        return raw
    }

    private func formatRefreshDate(_ date: Date?) -> String {
        guard let date else { return "-" }

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
