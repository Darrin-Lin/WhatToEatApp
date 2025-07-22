//
//  WeekdayChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct WeekdayChooseView: View {
    @Binding var selectedDays: UInt8
    
    let dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Open days").font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                ForEach(dayNames.indices, id: \.self) { i in
                    let selected = (selectedDays & (1 << i)) != 0
                    Text(dayNames[i])
                        .padding(6)
                        .frame(maxWidth: .infinity)
                        .background(selected ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedDays ^= (1 << i)
                        }
                }
            }
        }
    }
}
