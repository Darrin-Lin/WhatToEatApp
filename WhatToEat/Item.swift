//
//  Item.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/3/18.
//

import Foundation
import SwiftData

@Model
final class Item {
    @Attribute(.unique) var restaurant: String
    @Relationship var tags: [ItemTags]
    
    init(restaurant: String, tags: [ItemTags] = []) {
        self.restaurant = restaurant
        self.tags = tags
    }
}


@Model
final class ItemTags: Identifiable {
    @Attribute(.unique) var tag: String
    @Relationship(inverse: \Item.tags) var items: [Item]
    
    init(tag: String, items: [Item] = []) {
        self.tag = tag
        self.items = items
    }
}
