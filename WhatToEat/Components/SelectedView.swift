//
//  SelectedView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/22.
//

import SwiftUI

struct SelectedView: View {
    let matchedRestaurants: [String]
    @State private var isExpanded = false

    var body: some View {
        DisclosureGroup("Restaurants (\(matchedRestaurants.count))", isExpanded: $isExpanded) {
            if matchedRestaurants.isEmpty {
                Text("No matched restaurants")
                    .foregroundColor(.red)
                    .padding(.top, 8)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(matchedRestaurants, id: \.self) { name in
                            Text("• \(name)")
                        }
                    }
                    .padding(.top, 8)
                }
                .frame(maxHeight: 200)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .animation(.easeInOut, value: isExpanded)
    }
}
