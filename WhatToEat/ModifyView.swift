//
//  ContentView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/3/18.
//

import SwiftUI
import SwiftData

struct ModifyView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var items: [Item]
    @Query private var tag_list: [ItemTags]
    @State private var showingAddItemSheet = false
    @State private var showingAddTagSheet = false
    @State private var restaurant_name: String = ""
    @State private var price: (min:Int, max:Int) = (0,0)
    @State private var selectedDays: UInt8 = 0b1111111
    @State private var selectedHours: UInt32 = ((1<<24) - 1)
    @State private var rating: UInt8 = 0
    @State private var selectedTags: Set<ItemTags> = []
    @State private var newTag: String = ""
    
    var body: some View {
        NavigationSplitView {
            itemListView
        } detail: {
            Text("Select an item")
        }
    }
    
    @ViewBuilder
    var itemListView: some View {
        List {
            restaurantSection
            tagSection
        }
        .toolbar {
            toolbarContent
        }
        .sheet(isPresented: $showingAddItemSheet) {
            addRestaurantSheet
        }
        .sheet(isPresented: $showingAddTagSheet) {
            addTagSheet
        }
    }
    
    @ViewBuilder
    var restaurantSection: some View {
        Section(header: Text("restaurants")) {
            ForEach(items) { item in
                NavigationLink {
                    RestaurantDetailView(restaurant: item)
                } label: {
                    Text(item.restaurant)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    @ViewBuilder
    var tagSection: some View {
        Section(header: Text("tags")) {
            ForEach(tag_list) { tag_item in
                NavigationLink {
                    Section(header: Text("used by \(tag_item.items.count) restaurants")) {
                        List {
                            ForEach(tag_item.items) { item in
                                Text(item.restaurant)
                            }
                        }
                    }
                } label: {
                    Text(tag_item.tag)
                }
            }
            .onDelete(perform: deleteTags)
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
        ToolbarItem {
            Button(action: { showingAddItemSheet.toggle() }) {
                Label("Add Item", systemImage: "plus")
            }
        }
        ToolbarItem {
            Button(action: { showingAddTagSheet.toggle() }) {
                Label("Add Tag", systemImage: "tag.fill")
            }
        }
    }
    
    @ViewBuilder
    var addRestaurantSheet: some View {
        RestaurantSheetView(
            restaurantName: $restaurant_name,
            price: $price,
            selectedDays: $selectedDays,
            selectedHours: $selectedHours,
            rating: $rating,
            selectedTags: $selectedTags,
            tagList: tag_list,
            onAdd: {
                addRestaurant(
                    restaurant: restaurant_name,
                    tags: Array(selectedTags),
                    lowestPrice: price.min,
                    highestPrice: price.max,
                    weekBit: selectedDays,
                    hourBit: selectedHours,
                    rating0to10: UInt8(rating)
                )
                showingAddItemSheet = false
            }
        )
    }
    
    @ViewBuilder
    var addTagSheet: some View {
        VStack {
            TextField("New tag", text: $newTag)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Add Tag") {
                addNewTag(tag: newTag)
                newTag = ""
                showingAddTagSheet = false
            }
            .padding()
        }
        .padding()
    }
    
    private func addRestaurant(restaurant: String, tags: [ItemTags], lowestPrice:Int, highestPrice: Int, weekBit: UInt8, hourBit:UInt32, rating0to10: UInt8 ) {
        withAnimation {
            let newItem = Item(restaurant: restaurant, tags: tags, lowestPrice:lowestPrice, highestPrice: highestPrice, weekBit: weekBit, hourBit: hourBit, rating0to10: rating0to10)
            modelContext.insert(newItem)
            for tag in tags {
                tag.items.append(newItem)
            }
            restaurant_name = ""
            selectedTags.removeAll()
        }
    }
    
    private func addNewTag(tag: String) {
        withAnimation {
            if !tag_list.contains(where: { $0.tag == tag }) && !tag.isEmpty {
                let newTag = ItemTags(tag: tag)
                modelContext.insert(newTag)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let itemToDelete = items[index]
                for tag in tag_list {
                    if let idx = tag.items.firstIndex(of: itemToDelete) {
                        tag.items.remove(at: idx)
                        modelContext.insert(tag)
                    }
                }
                modelContext.delete(itemToDelete)
            }
        }
    }
    
    private func deleteTags(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let tagToDelete = tag_list[index]
                for item in items {
                    if let idx = item.tags.firstIndex(of: tagToDelete) {
                        item.tags.remove(at: idx)
                        modelContext.insert(item)
                    }
                }
                modelContext.delete(tagToDelete)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
