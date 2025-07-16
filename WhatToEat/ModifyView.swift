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
    @State private var selectedTags: Set<ItemTags> = []
    @State private var newTag: String = ""
    
    var body: some View {
        NavigationSplitView {
            List {
                Section(header: Text("restaurants")){
                    ForEach(items) { item in
                        NavigationLink {
                            RestaurantDetailView(restaurant: item)
                        } label: {
                            Text(item.restaurant)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                Section(header: Text("tags")){
                    ForEach(tag_list) { tag_item in
                        NavigationLink {
                            Section(header: Text("used by \(tag_item.items.count) restaurants")){
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
            .toolbar {
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
            .sheet(isPresented: $showingAddItemSheet) {
                VStack {
                    TextField("Restaurant", text: $restaurant_name)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Select tags").font(.headline)
                    ScrollView {
                        VStack {
                            ForEach(tag_list) { tag in
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
                        }.frame(maxHeight: 1000)
                    }
                    .padding()
                    
                    Button("Add Restaurant") {
                        addItem(restaurant: restaurant_name, tags: Array(selectedTags))
                        showingAddItemSheet = false
                    }
                    .padding()
                }
                .padding()
            }
            
            .sheet(isPresented: $showingAddTagSheet) {
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
        } detail: {
            Text("Select an item")
        }
    }
    
    private func addItem(restaurant: String, tags: [ItemTags]) {
        withAnimation {
            let newItem = Item(restaurant: restaurant, tags: tags)
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


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
