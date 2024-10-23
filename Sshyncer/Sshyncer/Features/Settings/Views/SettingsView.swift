//
//  SettingsView.swift
//  Sshyncer
//
//  Created by Jake Barnby on 17/10/2024.
//

import SwiftUI

#if os(macOS)
struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    
    @State private var selectedTab: String = "Account"
    
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
#else
struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    
    @State private var selectedTab: String = "Account"
    
    var body: some View {
        ScrollView {
            VStack {
                Picker("", selection: $selectedTab) {
                    Label("Account", systemImage: "person.crop.circle")
                        .tag("Account")
                    Label("Integrations", systemImage: "puzzlepiece.extension.fill")
                        .tag("Integrations")
                    Label("Updates", systemImage: "arrow.clockwise")
                        .tag("Updates")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selectedTab == "Account" {
                    AccountSettingsView()
                } else if selectedTab == "Integrations" {
                    IntegrationsSettingsView()
                } else if selectedTab == "Updates" {
                    UpdateSettingsView()
                }
            }
            .padding()
        }
    }
}
#endif

#Preview {
    SettingsView()
}
