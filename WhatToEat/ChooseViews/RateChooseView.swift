//
//  RateChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct RateChooseView: View {
    @Binding var minRating: UInt8
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Rating：\(minRating)★ ~ 10★").font(.headline)
            Slider(value: Binding(
                get: { Double(minRating) },
                set: { minRating = UInt8($0) }), in: 0...10, step: 1)
        }
    }
}

