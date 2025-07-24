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
    @Attribute var area: [ItemArea]
    @Attribute var lowestPrice: Int
    @Attribute var highestPrice: Int
    @Attribute var weekBit: UInt8
    @Attribute var hourBit: UInt32
    @Attribute var rating0to10: UInt8
    
    
    init(restaurant: String, tags: [ItemTags] = [], lowestPrice:Int, highestPrice:Int, weekBit: UInt8, hourBit: UInt32, rating0to10: UInt8, area: [ItemArea] = []) {
        self.restaurant = restaurant
        self.tags = tags
        self.lowestPrice = lowestPrice
        self.highestPrice = highestPrice
        self.weekBit = weekBit
        self.hourBit = hourBit
        self.rating0to10 = rating0to10
        self.area = area
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

@Model
final class ItemArea: Identifiable {
    @Attribute(.unique) var area: String
    @Relationship(inverse: \Item.area) var items: [Item]
    
    init(area: String, items: [Item] = []) {
        self.area = area
        self.items = items
    }
}
