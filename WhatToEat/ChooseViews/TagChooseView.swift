//
//  TagChooseView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct TagChooseView: View {
    let tagList: [ItemTags]
    @Binding var selectedTags: Set<ItemTags>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(tagList) { tag in
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
        .frame(height: 100)
    }

    private func toggleTag(_ tag: ItemTags) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
}
