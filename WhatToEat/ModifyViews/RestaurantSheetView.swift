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
    @Binding var selectedHours: UInt32
    @Binding var rating: UInt8
    @Binding var selectedTags: Set<ItemTags>
    @Binding var selectedAreas: Set<ItemArea>
    @State private var showTimeSelector = false
    let tagList: [ItemTags]
    let areaList: [ItemArea]
    let onAdd: () -> Void
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Restaurant", text: $restaurantName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Text("$")
                    TextField("Lowest Price", value: $price.min, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("~ $")
                    
                    TextField("Highest Price", value: $price.max, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                OpenTimeView(selectedDays: $selectedDays, selectedHours: $selectedHours)
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
                    TagChooseView(tagList: tagList, selectedTags: $selectedTags)
                    
                }
                .padding()
                .frame(maxHeight: 600)
                
                Text("Select Area").font(.headline)
                ScrollView {
                    AreaChooseView(areaList: areaList, selectedAreas: $selectedAreas)
                }
                .padding()
                .frame(maxHeight: 600)
                
                Button("Add Restaurant") {
                    onAdd()
                }
                .padding()
                .disabled(price.max < price.min)
            }
            .padding()
        }.dismissKeyboardOnTap()
    }
}
