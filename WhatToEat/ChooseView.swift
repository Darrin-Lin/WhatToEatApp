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
    @State private var selectedDays: UInt8 = 0b1111111
    @State private var selectedHours: UInt32 = ((1 << 24) - 1)
    @State private var priceRange: (min: Int, max: Int) = (0, 0)
    @State private var minRating: UInt8 = 0
    @State private var showTagSelector = false
    @State private var showResult = false
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Select tags")
                    .font(.title3)
                    .bold()
                
                Button(action: {
                    withAnimation(.spring()) {
                        showTagSelector = true
                    }
                }) {
                    Label("Select Tags", systemImage: "tag.fill")
                        .font(.headline)
                }
                MatchModeChooseView(matchMode: $matchMode)
                PriceChooseView(priceRange: $priceRange)
                RateChooseView(minRating: $minRating)
                OpenTimeView(selectedDays: $selectedDays, selectedHours: $selectedHours)
                NumberChooseView(numberToChoose: $numberToChoose, maxItems: items.count)
                
                let filtered = filterItems(items: items)
                let isDisabled = filtered.isEmpty

                Button("Choose") {
                    let filtered = filterItems(items: items)
                    let restaurants = filtered.map(\.restaurant).shuffled()
                    result = Array(restaurants.prefix(numberToChoose))
                    showResult = true
                }
                .disabled(isDisabled)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isDisabled ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            if showTagSelector {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack {
                    Spacer()
                    VStack(spacing: 20) {
                        Text("Select Tags")
                            .font(.title2)
                            .bold()
                        
                        ScrollView {
                            TagChooseView(tagList: tag_list, selectedTags: $selectedTags)
                        }
                        .frame(maxHeight: 400)
                        
                        Button("Finish") {
                            withAnimation {
                                showTagSelector = false
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .padding()
                    .transition(.move(edge: .bottom))
                }
                .zIndex(1)
            }
            if showResult {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack {
                    Spacer()
                    VStack(spacing: 20) {
                        ResultChooseView(results: result, onClose: {
                            withAnimation {
                                showResult = false
                            }
                        })
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .padding()
                    .transition(.move(edge: .bottom))
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(2)
            }
        }.animation(.easeInOut, value: showResult)
        
    }
    private func toggleTag(_ tag: ItemTags) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    private func filterItems(items: [Item]) -> [Item] {
        let baseMatched: [Item]
        switch matchMode {
        case .orMode:
            baseMatched = selectedTags.flatMap { $0.items }.uniqued()
        case .andMode:
            baseMatched = allItemsHavingAllTags()
        }
        
        return baseMatched.filter { item in
            (item.weekBit & selectedDays) != 0 &&
            (item.hourBit & selectedHours) != 0 &&
            item.lowestPrice >= priceRange.min &&
            item.highestPrice <= priceRange.max &&
            item.rating0to10 >= minRating
        }
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
