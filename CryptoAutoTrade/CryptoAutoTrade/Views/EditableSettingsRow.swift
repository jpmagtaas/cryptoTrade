//
//  EditableSettingsRow.swift
//  CryptoAutoTrade
//
//  Created by Juan Paolo Magtaas on 8/14/26.
//

import SwiftUI

struct EditableSettingRow<Content: View>: View {

    let title: String
    let value: String
    let isEditing: Bool
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack {
            Text(title)

            Spacer()

            if isEditing {
                content()
            } else {
                Text(value)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
