//
//  OpenTimeView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct OpenTimeView: View {
    @Binding var selectedDays: UInt8
    @Binding var selectedHours: UInt32
    @State private var isExpanded = false

    var body: some View {
        DisclosureGroup("Open time", isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 16) {

                // Open Days
                VStack(alignment: .leading) {
                    Text("Open Days")
                        .font(.subheadline)
                        .bold()

                    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(days.indices, id: \.self) { i in
                            let day = days[i]
                            let selected = (selectedDays & (1 << i)) != 0
                            Text(day)
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

                // Open Hours
                VStack(alignment: .leading) {
                    Text("Open Hours")
                        .font(.subheadline)
                        .bold()

                    let hours: [UInt32] = Array(0...23)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(hours.indices, id: \.self) { i in
                            let hour = hours[i]
                            let selected = (selectedHours & (1 << i)) != 0
                            Text("\(hour):00")
                                .padding(6)
                                .frame(maxWidth: .infinity)
                                .background(selected ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedHours ^= (1 << i)
                                }
                        }
                    }
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .animation(.easeInOut, value: isExpanded)
    }
}
