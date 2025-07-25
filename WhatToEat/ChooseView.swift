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
    @Query private var area_list: [ItemArea]
    @Query private var items: [Item]
    @State private var selectedTags: Set<ItemTags> = []
    @State private var selectedAreas: Set<ItemArea> = []
    @State private var result: [String] = []
    @State private var numberToChoose: Int = 1
    @State private var matchMode: MatchMode = .orMode
    @State private var selectedDays: UInt8 = 0b1111111
    @State private var selectedHours: UInt32 = ((1 << 24) - 1)
    @State private var priceRange: (min: Int, max: Int) = (0, 0)
    @State private var minRating: UInt8 = 0
    @State private var showTagSelector = false
    @State private var showAreaSelector = false
    @State private var showResult = false
    
    
    var body: some View {
        ZStack {
            ScrollView{
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
                    Button(action: {
                        withAnimation(.spring()) {
                            showAreaSelector = true
                        }
                    }) {
                        Label("Select Areas", systemImage: "map.fill")
                            .font(.headline)
                    }
                    let filtered = filterItems(items: items)
                    let isDisabled = filtered.isEmpty
                    MatchModeChooseView(matchMode: $matchMode)
                    PriceView(minPrice: $priceRange.min, maxPrice: $priceRange.max)
                    RateView(minRating: $minRating)
                    OpenTimeView(selectedDays: $selectedDays, selectedHours: $selectedHours)
                    NumberChooseView(numberToChoose: $numberToChoose, maxItems: filtered.count)
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
                    
                    SelectedView(matchedRestaurants: filtered.map { $0.restaurant })
                    Spacer()
                }
                .padding()
            }.padding()
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
            if showAreaSelector {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack {
                    Spacer()
                    VStack(spacing: 20) {
                        Text("Select Areas")
                            .font(.title2)
                            .bold()
                        ScrollView {
                            AreaChooseView(areaList: area_list, selectedAreas: $selectedAreas)
                        }
                        .frame(maxHeight: 400)
                        
                        Button("Finish") {
                            withAnimation {
                                showAreaSelector = false
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
            .dismissKeyboardOnTap()
    }
    private func toggleTag(_ tag: ItemTags) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    private func filterItems(items: [Item]) -> [Item] {
        var baseMatched: [Item]
        if !selectedTags.isEmpty {
            switch matchMode {
            case .orMode:
                baseMatched = selectedTags.flatMap { $0.items }.uniqued()
            case .andMode:
                baseMatched = allItemsHavingAllTags()
            }
        }
        else {
            baseMatched = items
        }
        if !selectedAreas.isEmpty {
            baseMatched = selectedAreas.flatMap { $0.items }.uniqued()
        }
        return baseMatched.filter { item in
            (item.weekBit & selectedDays) != 0 &&
            (item.hourBit & selectedHours) != 0 &&
            max(item.lowestPrice, priceRange.min) <= min(item.highestPrice, priceRange.max) &&
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
