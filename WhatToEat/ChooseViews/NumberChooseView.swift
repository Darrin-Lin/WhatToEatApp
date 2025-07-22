//
//  NumberChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct NumberChooseView: View {
    @Binding var numberToChoose: Int
    let maxItems: Int

    var body: some View {
        Stepper(value: $numberToChoose, in: 1...max(maxItems, 1)) {
            Text("Choose ").foregroundColor(.gray) +
            Text("\(numberToChoose)")
                .bold()
                .foregroundColor(.blue) +
            Text(" restaurants") .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}
