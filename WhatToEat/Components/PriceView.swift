//
//  PriceView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct PriceView: View {
    @Binding var minPrice: Int
    @Binding var maxPrice: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("Pirce Range").font(.headline)
            HStack {
                TextField("Lowest Price", value: $minPrice, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Text("~")

                TextField("Highest Price", value: $maxPrice, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}
