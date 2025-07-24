//
//  AreaSheetView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/7/24.
//

import SwiftUI

struct AreaSheetView: View {
    @Binding var newArea: String
    let onAdd: () -> Void
    var body: some View {
        VStack {
            TextField("New area", text: $newArea)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Add Area") {
                onAdd()
            }
            .padding()
        }
        .padding()
        .dismissKeyboardOnTap()
    }
}
