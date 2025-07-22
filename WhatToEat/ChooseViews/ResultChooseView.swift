//
//  ResultChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct ResultChooseView: View {
    let results: [String]

    var body: some View {
        if results.isEmpty {
            Text("no result").foregroundColor(.red)
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(results, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
            }
            .frame(maxHeight: 200)
            .padding()
        }
    }
}
