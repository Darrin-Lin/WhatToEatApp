//
//  MatchModeChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct MatchModeChooseView: View {
    @Binding var matchMode: MatchMode

    var body: some View {
        Picker("logic", selection: $matchMode) {
            ForEach(MatchMode.allCases) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}
