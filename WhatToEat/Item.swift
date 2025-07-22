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
    @Attribute var lowestPrice: Int
    @Attribute var highestPrice: Int
    @Attribute var openBit: UInt8
    @Attribute var rating0to10: UInt8
    
    init(restaurant: String, tags: [ItemTags] = [], lowestPrice:Int, highestPrice:Int, openBit: UInt8, rating0to10: UInt8) {
        self.restaurant = restaurant
        self.tags = tags
        self.lowestPrice = lowestPrice
        self.highestPrice = highestPrice
        self.openBit = openBit
        self.rating0to10 = rating0to10
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
