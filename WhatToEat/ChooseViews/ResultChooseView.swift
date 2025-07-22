//
//  ResultChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct ResultChooseView: View {
    let results: [String]
    let onClose: () -> Void
    
    var body: some View {
        if results.isEmpty {
            Text("no result").foregroundColor(.red)
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(results, id: \.self) { item in
                        Text("• \(item)")
                            .font(.title)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 600)
            .padding()
        }
        Button("Close") {
            withAnimation { onClose() }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}
