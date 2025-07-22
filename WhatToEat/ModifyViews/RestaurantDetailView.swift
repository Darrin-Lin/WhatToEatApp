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
    @State private var selectedTag: ItemTags? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tags for \(restaurant.restaurant):")
                .font(.headline)
            
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            ScrollView {
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
            
            Spacer()
        }
        .padding()
        .navigationTitle(restaurant.restaurant)
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
}
