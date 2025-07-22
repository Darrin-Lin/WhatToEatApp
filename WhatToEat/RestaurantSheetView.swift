//
//  RestaurantSheetView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct RestaurantSheetView: View {
    @Binding var restaurantName: String
    @Binding var price: (min: Int, max: Int)
    @Binding var selectedDays: UInt8
    @Binding var rating: UInt8
    @Binding var selectedTags: Set<ItemTags>
    let tagList: [ItemTags]
    let onAdd: () -> Void
    
    var body: some View {
        VStack {
            TextField("Restaurant", text: $restaurantName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                TextField("Lowest Price", value: $price.min, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("~")
                
                TextField("Highest Price", value: $price.max, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Open days").font(.headline)
                let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                    ForEach(days.indices, id: \.self) { i in
                        let day = days[i]
                        let selected = (selectedDays & (1<<i)) != 0
                        Text(day)
                            .padding(6)
                            .frame(maxWidth: .infinity)
                            .background(selected ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedDays ^= (1<<i)
                            }
                    }
                }
            }
            .padding()
            VStack {
                Text("Rating：\(rating)★")
                    .font(.headline)
                Slider(value: Binding(
                    get: { Double(rating) },
                    set: { rating = UInt8($0) }), in: 0...10, step: 1)
            }
            .padding()
            
            Text("Select tags").font(.headline)
            ScrollView {
                VStack {
                    ForEach(tagList) { tag in
                        HStack {
                            Text(tag.tag)
                            Spacer()
                            if selectedTags.contains(tag) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }
                    }
                }
                .frame(maxHeight: 1000)
            }
            .padding()
            
            Button("Add Restaurant") {
                onAdd()
            }
            .padding()
            .disabled(price.max < price.min)
        }
        .padding()
    }
}
