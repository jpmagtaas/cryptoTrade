//
//  SettingsView.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 7/30/26.
//

import SwiftUI

struct SettingsView: View {

    @StateObject
    private var viewModel = SettingsViewModel()

    @State private var isEditing = false
    @State private var draft: BotConfigResponse?
    
    var body: some View {

        List {

            if let config = viewModel.config {

                Section("Market") {

                    EditableSettingRow(
                        title: "Symbol",
                        value: config.symbol,
                        isEditing: isEditing
                    ) {
                        TextField(
                            "",
                            text: Binding(
                                get: {
                                    draft?.symbol ?? ""
                                },
                                set: {
                                    draft?.symbol = $0
                                }
                            )
                        )
                        .frame(width: 100)
                        .multilineTextAlignment(.trailing)
                    }

                    EditableSettingRow(
                        title: "Timeframe",
                        value: config.timeframe,
                        isEditing: isEditing
                    ) {
                        Picker(
                            "",
                            selection: Binding(
                                get: {
                                    draft?.timeframe ?? "1h"
                                },
                                set: {
                                    draft?.timeframe = $0
                                }
                            )
                        ) {
                            Text("15m").tag("15m")
                            Text("30m").tag("30m")
                            Text("1h").tag("1h")
                            Text("4h").tag("4h")
                            Text("1d").tag("1d")
                        }
                        .labelsHidden()
                    }

                    EditableSettingRow(
                        title: "Strategy",
                        value: config.strategyName,
                        isEditing: isEditing
                    ) {
                        Picker(
                            "",
                            selection: Binding(
                                get: {
                                    draft?.strategyName ?? "breakout"
                                },
                                set: {
                                    draft?.strategyName = $0
                                }
                            )
                        ) {
                            Text("Breakout")
                                .tag("breakout")
                        }
                        .labelsHidden()
                    }
                    
                    LabeledContent(
                        "Starting Balance",
                        value: String(
                            format: "$%.2f",
                            config.startingBalance
                        )
                    )

                }

                Section("Risk") {

                    EditableSettingRow(
                        title: "Risk Per Trade",
                        value: "\(Int(config.riskPerTrade * 100))%",
                        isEditing: isEditing
                    ) {
                        if let _ = draft {
                            TextField(
                                "",
                                value: Binding(
                                    get: {
                                        draft?.riskPerTrade ?? 0
                                    },
                                    set: {
                                        draft?.riskPerTrade = $0
                                    }
                                ),
                                format: .number
                            )
                            .frame(width: 70)
                            .multilineTextAlignment(.trailing)
                        }
                    }

                    EditableSettingRow(
                        title: "Stop Loss",
                        value: "\(config.stopLossPercent * 100)%",
                        isEditing: isEditing
                    ) {
                        TextField(
                            "",
                            value: Binding(
                                get: {
                                    draft?.stopLossPercent ?? 0
                                },
                                set: {
                                    draft?.stopLossPercent = $0
                                }
                            ),
                            format: .number
                        )
                        .frame(width: 70)
                        .multilineTextAlignment(.trailing)
                    }

                    EditableSettingRow(
                        title: "Take Profit",
                        value: "\(config.takeProfitPercent * 100)%",
                        isEditing: isEditing
                    ) {
                        TextField(
                            "",
                            value: Binding(
                                get: {
                                    draft?.takeProfitPercent ?? 0
                                },
                                set: {
                                    draft?.takeProfitPercent = $0
                                }
                            ),
                            format: .number
                        )
                        .frame(width: 70)
                        .multilineTextAlignment(.trailing)
                    }

                    EditableSettingRow(
                        title: "Trading Fee",
                        value: "\(config.tradingFee * 100)%",
                        isEditing: isEditing
                    ) {
                        TextField(
                            "",
                            value: Binding(
                                get: {
                                    draft?.tradingFee ?? 0
                                },
                                set: {
                                    draft?.tradingFee = $0
                                }
                            ),
                            format: .number
                        )
                        .frame(width: 70)
                        .multilineTextAlignment(.trailing)
                    }

                }

                Section("Breakout Strategy") {

                    EditableSettingRow(
                        title: "Lookback",
                        value: "\(config.breakoutLookback)",
                        isEditing: isEditing
                    ) {
                        Stepper(
                            "",
                            value: Binding(
                                get: {
                                    draft?.breakoutLookback ?? 10
                                },
                                set: {
                                    draft?.breakoutLookback = $0
                                }
                            ),
                            in: 2...100
                        )
                    }

                    EditableSettingRow(
                        title: "Volume Lookback",
                        value: "\(config.volumeLookback)",
                        isEditing: isEditing
                    ) {
                        Stepper(
                            "",
                            value: Binding(
                                get: {
                                    draft?.volumeLookback ?? 20
                                },
                                set: {
                                    draft?.volumeLookback = $0
                                }
                            ),
                            in: 2...100
                        )
                    }

                    EditableSettingRow(
                        title: "Breakout Buffer",
                        value: String(format: "%.4f", config.breakoutBuffer),
                        isEditing: isEditing
                    ) {
                        TextField(
                            "",
                            value: Binding(
                                get: {
                                    draft?.breakoutBuffer ?? 1.0015
                                },
                                set: {
                                    draft?.breakoutBuffer = $0
                                }
                            ),
                            format: .number.precision(
                                .fractionLength(4)
                            )
                        )
                        .frame(width: 90)
                        .multilineTextAlignment(.trailing)
                    }

                    EditableSettingRow(
                        title: "Volume Multiplier",
                        value: String(format: "%.2f", config.volumeMultiplier),
                        isEditing: isEditing
                    ) {
                        TextField(
                            "",
                            value: Binding(
                                get: {
                                    draft?.volumeMultiplier ?? 1.0
                                },
                                set: {
                                    draft?.volumeMultiplier = $0
                                }
                            ),
                            format: .number
                                .precision(.fractionLength(2))
                        )
                        .frame(width: 90)
                        .multilineTextAlignment(.trailing)
                    }

                }

            }

        }
        .navigationTitle("Settings")
        .task {

            await viewModel.load()

            draft = viewModel.config

        }
        .toolbar {

            ToolbarItem(placement: .topBarLeading) {

                if isEditing {

                    Button("Cancel") {

                        draft = viewModel.config
                        isEditing = false

                    }

                }

            }

            ToolbarItem(placement: .topBarTrailing) {

                if isEditing {

                    Button("Save") {

                        guard let draft else {
                            return
                        }

                        if let error = viewModel.validate(draft) {
                            viewModel.errorMessage = error
                            return
                        }

                        Task {
                            await viewModel.save(draft)

                            if viewModel.errorMessage == nil {
                                self.draft = viewModel.config
                                isEditing = false
                            }
                        }
                    }

                } else {

                    Button("Edit") {

                        draft = viewModel.config
                        isEditing = true

                    }

                }

            }

        }
        .alert(
            "Invalid Settings",
            isPresented: Binding(
                get: {
                    viewModel.errorMessage != nil
                },
                set: {
                    if !$0 {
                        viewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }

    }
    

}
