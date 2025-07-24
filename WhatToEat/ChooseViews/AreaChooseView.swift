//
//  AreaChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct AreaChooseView: View {
    let areaList: [ItemArea]
    @Binding var selectedAreas: Set<ItemArea>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(areaList) { area in
                    HStack {
                        Text(area.area)
                        Spacer()
                        Image(systemName: selectedAreas.contains(area) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedAreas.contains(area) ? .blue : .gray)
                    }
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleArea(area)
                    }
                }
            }
        }
        .frame(height: 100)
    }

    private func toggleArea(_ area: ItemArea) {
        if selectedAreas.contains(area) {
            selectedAreas.remove(area)
        } else {
            selectedAreas.insert(area)
        }
    }
}
