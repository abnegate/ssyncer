//
//  SshyncerApp.swift
//  Sshyncer
//
//  Created by Jake Barnby on 17/10/2024.
//

import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = AppViewModel()
    
    var body: some View {
        SshyncerNavigationView(viewModel: viewModel)
            .environmentObject(Appwrite())
    }
}

#if os(macOS)
struct SshyncerNavigationView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationSplitView {
            List(selection: $viewModel.selectedTab) {
                NavigationLink(value: Screen.hosts.rawValue) {
                    Label("Hosts", systemImage: "server.rack")
                }
                NavigationLink(value: Screen.keys.rawValue) {
                    Label("Keys", systemImage: "key")
                }
                NavigationLink(value: Screen.settings.rawValue) {
                    Label("Settings", systemImage: "gear")
                }
            }
            .listStyle(SidebarListStyle())
        } detail: {
            VStack {
                let path = getNavigationPath(for: viewModel.selectedTab)
                
                if !path.isEmpty {
                    Button(action: { popNavigationStack(for: viewModel.selectedTab) }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .padding()
                }
                
                switch viewModel.selectedTab {
                case .hosts:
                    NavigationStack(path: $viewModel.hostsNavigationPath) {
                        HostsView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        viewModel.showingModal = .addHost
                                    }) {
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                            .sheet(isPresented: Binding(
                                get: { viewModel.showingModal == .addHost },
                                set: { if !$0 { viewModel.showingModal = .none } }
                            )) {
                                AddHostView()
                            }
                    }
                case .keys:
                    NavigationStack(path: $viewModel.keysNavigationPath) {
                        KeyListView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        viewModel.showingModal = .addKey
                                    }) {
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                            .sheet(isPresented: Binding(
                                get: { viewModel.showingModal == .addKey },
                                set: { if !$0 { viewModel.showingModal = .none } }
                            )) {
                                AddKeyView()
                            }
                    }
                case .settings:
                    NavigationStack(path: $viewModel.settingsNavigationPath) {
                        SettingsView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}
#else
struct SshyncerNavigationView: View {
    @Binding var selectedTab: Screen
    @Binding var showingModal: Modal
    @Binding var hostsNavigationPath: NavigationPath
    @Binding var keysNavigationPath: NavigationPath
    @Binding var settingsNavigationPath: NavigationPath
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $hostsNavigationPath) {
                HostsView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AddHostView()) {
                                Image(systemName: "plus")
                            }
                        }
                    }
            }
            .tabItem {
                Label("Hosts", systemImage: "server.rack")
            }
            .tag(Screen.hosts.rawValue)
            
            NavigationStack(path: $keysNavigationPath) {
                KeysView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AddKeyView()) {
                                Image(systemName: "plus")
                            }
                        }
                    }
            }
            .tabItem {
                Label("Keys", systemImage: "key")
            }
            .tag(Screen.keys.rawValue)
            
            NavigationStack(path: $settingsNavigationPath) {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(Screen.settings.rawValue)
        }
    }
}
#endif

extension SshyncerNavigationView {
    // Get the current NavigationPath based on the selected tab
    private func getNavigationPath(for tab: Screen) -> NavigationPath {
        switch tab {
        case .hosts:
            return viewModel.hostsNavigationPath
        case .keys:
            return viewModel.keysNavigationPath
        case .settings:
            return viewModel.settingsNavigationPath
        }
    }
    
    // Pop the last view in the stack for the selected tab
    private func popNavigationStack(for tab: Screen) {
        switch tab {
        case .hosts:
            if !viewModel.hostsNavigationPath.isEmpty {
                viewModel.hostsNavigationPath.removeLast()
            }
        case .keys:
            if !viewModel.keysNavigationPath.isEmpty {
                viewModel.keysNavigationPath.removeLast()
            }
        case .settings:
            if !viewModel.settingsNavigationPath.isEmpty {
                viewModel.settingsNavigationPath.removeLast()
            }
        }
    }
}

#Preview {
    ContentView()
}
