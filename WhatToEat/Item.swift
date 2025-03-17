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
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
