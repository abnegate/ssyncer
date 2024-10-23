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
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

struct ContentView: View {
    @StateObject var viewModel = AppViewModel()
    
    var body: some View {
        SshyncerNavigationView(viewModel: viewModel)
            .registerOAuthHandler()
    }
}

#if os(macOS)
struct SshyncerNavigationView: View {
    @ObservedObject var viewModel: AppViewModel
    
    @State var selectedTab = Screen.hosts
    @State var showingModal = Modal.none
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                NavigationLink(value: Screen.hosts) {
                    Label("Hosts", systemImage: "server.rack")
                }
                NavigationLink(value: Screen.keys) {
                    Label("Keys", systemImage: "key")
                }
                NavigationLink(value: Screen.tunnels) {
                    Label("Tunnels", systemImage: "tram.fill.tunnel")
                }
            }
            .listStyle(SidebarListStyle())
        } detail: {
            VStack {
                let path = getNavigationPath(for: selectedTab)
                
                if !path.isEmpty {
                    Button(action: { popNavigationStack(for: selectedTab) }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .padding()
                }
                
                switch selectedTab {
                case .hosts:
                    NavigationStack(path: $viewModel.hostsNavigationPath) {
                        HostListView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        showingModal = .addHost
                                    }) {
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                            .sheet(isPresented: Binding(
                                get: { showingModal == .addHost },
                                set: { if !$0 { showingModal = .none } }
                            )) {
                                HostAddView()
                            }
                    }
                case .keys:
                    NavigationStack(path: $viewModel.keysNavigationPath) {
                        KeyListView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        showingModal = .addKey
                                    }) {
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                            .sheet(isPresented: Binding(
                                get: { showingModal == .addKey },
                                set: { if !$0 { showingModal = .none } }
                            )) {
                                AddKeyView()
                            }
                    }
                case .tunnels:
                    NavigationStack(path: $viewModel.tunnelsNavigationPath) {
                        TunnelListView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        showingModal = .addTunnel
                                    }) {
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                            .sheet(isPresented: Binding(
                                get: { showingModal == .addTunnel },
                                set: { if !$0 { showingModal = .none } }
                            )) {
                                TunnelAddView()
                            }
                    }
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}
#else
struct SshyncerNavigationView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationStack(path: $viewModel.hostsNavigationPath) {
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
            
            NavigationStack(path: $viewModel.keysNavigationPath) {
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
            
            NavigationStack(path: $viewModel.settingsNavigationPath) {
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
        case .tunnels:
            return viewModel.tunnelsNavigationPath
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
        case .tunnels:
            if !viewModel.tunnelsNavigationPath.isEmpty {
                viewModel.tunnelsNavigationPath.removeLast()
            }
        }
    }
}

#Preview {
    ContentView()
}
