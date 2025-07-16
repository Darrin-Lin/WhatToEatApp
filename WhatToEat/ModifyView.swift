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
                            Text("Item at \(item.restaurant)")
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
                modelContext.delete(items[index])
                for i in tag_list {
                    if let idx = i.items.firstIndex(of: items[index]){
                        i.items.remove(at: idx)
                    }
                }
            }
        }
    }
    
    private func deleteTags(offsets: IndexSet) {
        withAnimation {
            for index in offsets{
                modelContext.delete(tag_list[index])
                for i in items {
                    if let idx = i.tags.firstIndex(of: tag_list[index]){
                        i.tags.remove(at: idx)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
