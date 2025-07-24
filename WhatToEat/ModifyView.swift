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
    @Query private var area_list: [ItemArea]
    @State private var showingAddItemSheet = false
    @State private var showingAddTagSheet = false
    @State private var showingAddAreaSheet = false
    @State private var restaurant_name: String = ""
    @State private var price: (min:Int, max:Int) = (0,0)
    @State private var selectedDays: UInt8 = 0b1111111
    @State private var selectedHours: UInt32 = ((1<<24) - 1)
    @State private var rating: UInt8 = 0
    @State private var selectedTags: Set<ItemTags> = []
    @State private var selectedArea: Set<ItemArea> = []
    @State private var newTag: String = ""
    @State private var newArea: String = ""
    
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
            ModifySections.restaurantSection(items: items, deleteItems: deleteItems)
            ModifySections.tagSection(tagList: tag_list, deleteTags: deleteTags)
            ModifySections.areaSection(areaList: area_list, deleteArea: deleteArea)
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
        .sheet(isPresented: $showingAddAreaSheet) {
            addAreaSheet
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
        ToolbarItem {
            Button(action: { showingAddAreaSheet.toggle()}){
                Label("Add Area", systemImage: "map.fill")
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
            selectedAreas: $selectedArea,
            tagList: tag_list,
            areaList: area_list,
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
        TagSheetView(
            newTag: $newTag,
            onAdd: {
                addNewTag(tag: newTag)
                newTag = ""
                showingAddTagSheet = false
            }
        )
    }
    
    @ViewBuilder
    var addAreaSheet: some View {
        AreaSheetView(
            newArea: $newArea,
            onAdd: {
                addNewArea(area: newArea)
                newArea = ""
                showingAddAreaSheet = false
        })
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
    
    private func addNewArea(area: String) {
        withAnimation {
            if !area_list.contains(where: { $0.area == area }) && !area.isEmpty {
                let newArea = ItemArea(area: area)
                modelContext.insert(newArea)
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
    
    private func deleteArea(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let areaToDelete = area_list[index]
                for item in items {
                    if let idx = item.area.firstIndex(of: areaToDelete) {
                        item.area.remove(at: idx)
                        modelContext.insert(item)
                    }
                }
                modelContext.delete(areaToDelete)
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
