//
//  SettingsView.swift
//  Sshyncer
//
//  Created by Jake Barnby on 17/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    
    @State private var selectedTab: String = "General" // Initial selected tab
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                AccountSettingsView()
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle")
                    }
                    .tag("Account")
                
                IntegrationsSettingsView()
                    .tabItem {
                        Label("Integrations", systemImage: "puzzlepiece.extension.fill")
                    }
                    .tag("Integrations")
                
                UpdateSettingsView()
                    .tabItem {
                        Label("Updates", systemImage: "arrow.clockwise")
                    }
                    .tag("Updates")
            }
            .frame(minWidth: 600, minHeight: 400)
        }
    }
}

#Preview {
    SettingsView()
}
