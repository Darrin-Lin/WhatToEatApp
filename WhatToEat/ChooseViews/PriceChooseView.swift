//
//  PriceChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct PriceChooseView: View {
    @Binding var priceRange: (min: Int, max: Int)

    var body: some View {
        VStack(alignment: .leading) {
            Text("Pirce Range").font(.headline)
            HStack {
                TextField("Lowest Price", value: $priceRange.min, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Text("~")

                TextField("Highest Price", value: $priceRange.max, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}
