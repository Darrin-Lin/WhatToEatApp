//
//  ChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/3/19.
//

import SwiftUI
import SwiftData

enum MatchMode: String, CaseIterable, Identifiable {
    case orMode = "OR"
    case andMode = "AND"
    var id: String { self.rawValue }
}
struct ChooseView: View {
    @Query private var tag_list: [ItemTags]
    @Query private var items: [Item]
    @State private var selectedTags: Set<ItemTags> = []
    @State private var result: [String] = []
    @State private var numberToChoose: Int = 1
    @State private var matchMode: MatchMode = .orMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select tags")
                .font(.title3)
                .bold()

            TagChooseView(tagList: tag_list, selectedTags: $selectedTags)

            MatchModeChooseView(matchMode: $matchMode)

            NumberChooseView(numberToChoose: $numberToChoose, maxItems: items.count)

            Button("Choose") {
                result = random_gen(num: numberToChoose)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            ResultChooseView(results: result)

            Spacer()
        }
        .padding()
    }
    private func toggleTag(_ tag: ItemTags) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    
    private func random_gen(num: Int) -> [String] {
        if selectedTags.isEmpty { return [] }
        
        let matchedItems: [Item]
        
        switch matchMode {
        case .orMode:
            matchedItems = selectedTags
                .flatMap { $0.items }
                .uniqued()
        case .andMode:
            matchedItems = allItemsHavingAllTags()
        }
        let restaurants = matchedItems.map { $0.restaurant }.shuffled()
        return Array(restaurants.prefix(num >= matchedItems.count ? matchedItems.count:num))
    }
    
    private func allItemsHavingAllTags() -> [Item] {
        guard let firstTag = selectedTags.first else { return [] }
        let selectedTagSet = Set(selectedTags)
        return firstTag.items.filter { item in
            selectedTagSet.isSubset(of: Set(item.tags))
        }
    }
}

// the tool remove same in array
extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        Array(Set(self))
    }
}
