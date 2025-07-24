//
//  ModifySectionsView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/24.
//

import SwiftUI

struct ModifySections {
    static func restaurantSection(items: [Item], deleteItems: @escaping (IndexSet) -> Void) -> some View {
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
    
    static func tagSection(tagList: [ItemTags], deleteTags: @escaping (IndexSet) -> Void) -> some View {
        Section(header: Text("tags")) {
            ForEach(tagList) { tag_item in
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
    
    static func areaSection(areaList: [ItemArea], deleteArea: @escaping (IndexSet) -> Void) -> some View {
        Section(header: Text("areas")) {
            ForEach(areaList) { area_item in
                NavigationLink(destination: AreaDetailView(area: area_item)) {
                    Text(area_item.area)
                }
            }
            .onDelete(perform: deleteArea)
        }
    }
}

struct AreaDetailView: View {
    let area: ItemArea
    
    var body: some View {
        List {
            Section(header: Text("used by \(area.items.count) restaurants")) {
                ForEach(area.items) { item in
                    Text(item.restaurant)
                }
            }
        }
        .navigationTitle(area.area)
    }
}
