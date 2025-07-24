//
//  RestaurantDetailView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI
import SwiftData

struct RestaurantDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var restaurant: Item
    @Query private var allTags: [ItemTags]
    @Query private var allArea: [ItemArea]
    @State private var selectedTag: ItemTags? = nil
    @State private var selectedArea: ItemArea? = nil
    @State var selectedDays: UInt8 = 0
    @State var selectedTime: UInt32 = 0
    @State var rating: UInt8 = 0
    @State var price: (min: Int, max: Int) = (0, 0)
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                ScrollView {
                    Text("Tags for \(restaurant.restaurant):")
                        .font(.headline)
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                        ForEach(restaurant.tags, id: \.tag) { tag in
                            Text(tag.tag)
                                .padding(6)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                                .onLongPressGesture {
                                    removeTag(tag)
                                }
                        }
                    }.padding()
                    Text("Area for \(restaurant.restaurant):")
                        .font(.headline)
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                        ForEach(restaurant.area, id: \.area) { area in
                            Text(area.area)
                                .padding(6)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                                .onLongPressGesture {
                                    removeArea(area)
                                }
                        }
                        
                    }.padding()
                }
                .frame(maxHeight: 200)
                Divider()
                
                let availableTags = allTags.filter { !restaurant.tags.contains($0) }
                
                if availableTags.isEmpty {
                    Text("No tags available to add")
                        .foregroundColor(.gray)
                } else {
                    HStack {
                        Menu {
                            ForEach(availableTags, id: \.tag) { tag in
                                Button(tag.tag) {
                                    selectedTag = tag
                                }
                            }
                        } label: {
                            Text(selectedTag?.tag ?? "Select tag to add")
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                        
                        Button("Add") {
                            if let tag = selectedTag {
                                addTag(tag)
                                selectedTag = nil
                            }
                        }
                        .disabled(selectedTag == nil)
                        .padding(.leading)
                    }
                }
                let availableArea = allArea.filter { !restaurant.area.contains($0) }
                
                if availableArea.isEmpty {
                    Text("No area available to add")
                        .foregroundColor(.gray)
                } else {
                    HStack {
                        Menu {
                            ForEach(availableArea, id: \.area) { area in
                                Button(area.area) {
                                    selectedArea = area
                                }
                            }
                        } label: {
                            Text(selectedArea?.area ?? "Select area to add")
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                        
                        Button("Add") {
                            if let area = selectedArea {
                                addArea(area)
                                selectedArea = nil
                            }
                        }
                        .disabled(selectedArea == nil)
                        .padding(.leading)
                    }
                }
                VStack{
                    PriceView(minPrice: $restaurant.lowestPrice,
                              maxPrice: $restaurant.highestPrice)
                    RateView(minRating: $restaurant.rating0to10)
                    OpenTimeView(selectedDays: $restaurant.weekBit, selectedHours: $restaurant.hourBit)
                }
                Spacer()
            }
            .padding()
            .navigationTitle(restaurant.restaurant)
        }.dismissKeyboardOnTap()
    }
    
    private func addTag(_ tag: ItemTags) {
        restaurant.tags.append(tag)
        tag.items.append(restaurant)
        
        modelContext.insert(restaurant)
        modelContext.insert(tag)
    }
    private func removeTag(_ tag: ItemTags) {
        withAnimation {
            if let index = restaurant.tags.firstIndex(of: tag) {
                restaurant.tags.remove(at: index)
            }
            if let index = tag.items.firstIndex(of: restaurant) {
                tag.items.remove(at: index)
            }
            
            modelContext.insert(restaurant)
            modelContext.insert(tag)
        }
    }
    
    private func addArea(_ area: ItemArea) {
        restaurant.area.append(area)
        area.items.append(restaurant)
        
        modelContext.insert(restaurant)
        modelContext.insert(area)
    }
    private func removeArea(_ area: ItemArea) {
        withAnimation {
            if let index = restaurant.area.firstIndex(of: area) {
                restaurant.area.remove(at: index)
            }
            if let index = area.items.firstIndex(of: restaurant) {
                area.items.remove(at: index)
            }
            
            modelContext.insert(restaurant)
            modelContext.insert(area)
        }
    }
}
