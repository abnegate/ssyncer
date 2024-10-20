//
//  AppViewModel.swift
//  Sshyncer
//
//  Created by Jake Barnby on 20/10/2024.
//

import SwiftUI

class AppViewModel : ViewModel {
    private var appwrite: Appwrite
    
    @Published var selectedTab: Screen
    @Published var showingModal: Modal
    @Published var hostsNavigationPath: NavigationPath
    @Published var keysNavigationPath: NavigationPath
    @Published var settingsNavigationPath: NavigationPath
    
    override init() {
        appwrite = .init()
        selectedTab = .hosts
        showingModal = .none
        hostsNavigationPath = .init()
        keysNavigationPath = .init()
        settingsNavigationPath = .init()
        
        super.init()
        
        Task {
            // TODO: Check if one exists here first
            try await appwrite.createAnonymousSession()
        }
    }
}
