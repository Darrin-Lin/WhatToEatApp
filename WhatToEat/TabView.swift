//
//  TabView.swift
//  WhatToEat
//
//  Created by Darrin Lin on 2025/3/19.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView {
            ModifyView()
                .tabItem {
                    Label("Modify", systemImage: "slider.horizontal.3")
                }
        }
    }
}

