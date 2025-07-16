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
            
            // tags list
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(tag_list) { tag in
                        HStack {
                            Text(tag.tag)
                            Spacer()
                            Image(systemName: selectedTags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedTags.contains(tag) ? .blue : .gray)
                        }
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleTag(tag)
                        }
                    }
                }
            }
            .frame(height: 200)
            
            // AND / OR choose
            VStack {
                
                Picker("logic", selection: $matchMode) {
                    ForEach(MatchMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            
            // number of restaurant choose
            Stepper(value: $numberToChoose, in: 1...max(items.count, 1)) {
                Text("Choose ").foregroundColor(.gray) +
                Text("\(numberToChoose)")
                    .bold()
                    .foregroundColor(.blue) +
                Text(" restaurants") .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // choose button
            Button("Choose") {
                result = random_gen(num: numberToChoose)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // result
            if !result.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(result, id: \.self) { item in
                                    Text("• \(item)")
                                }
                            }
                        }
                        .frame(maxHeight: 200) 
                }
                .padding()
            }
            else {
                Text("no result").foregroundColor(.red)
            }
            
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
