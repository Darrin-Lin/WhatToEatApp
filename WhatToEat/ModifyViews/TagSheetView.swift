//
//  TagSheetView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/24.
//

import SwiftUI

struct TagSheetView: View {
    @Binding var newTag: String
    let onAdd: () -> Void
    var body: some View {
        VStack {
            TextField("New tag", text: $newTag)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Add Tag") {
                onAdd()
            }
            .padding()
        }
        .padding()
        .dismissKeyboardOnTap()
    }
}
