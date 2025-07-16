//
//  ChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/3/19.
//

import SwiftUI
import SwiftData


struct ChooseView: View {
    @Query private var select_item: [Item]
    @State private var result: [String] = []
    @State private var numberToChoose: Int = 3
    var body: some View {
        VStack(spacing: 20) {
            Text("How many restaurants do you want to get?")
                .font(.headline)
            Stepper(value: $numberToChoose, in: 1...max(select_item.count, 1)) {
                Text("\(numberToChoose)")
            }
            .padding(.horizontal)
            
            Button(action: {
                result = random_gen(num: numberToChoose)
            }) {
                Text("Choose")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if !result.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(result, id: \.self) { item in
                        Text("• \(item)")
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func random_gen(num: Int) -> [String] {
        var rand_item = select_item.map { $0.restaurant }
        rand_item.shuffle()
        print(select_item)
        return Array(rand_item.prefix(num))
    }
}


#Preview {
    ChooseView()
}
