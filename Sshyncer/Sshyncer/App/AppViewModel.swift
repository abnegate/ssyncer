//
//  AppViewModel.swift
//  Sshyncer
//
//  Created by Jake Barnby on 20/10/2024.
//

import SwiftUI

class AppViewModel : ViewModel {
    @Published var appwrite = Cloud.shared
    @Published var hostsNavigationPath = NavigationPath()
    @Published var keysNavigationPath = NavigationPath()
    @Published var tunnelsNavigationPath = NavigationPath()
    @Published var settingsNavigationPath = NavigationPath()
    
    override init() {
        super.init()
        
        Task {
            if !(await appwrite.isLoggedIn()) {
                try? await appwrite.createAnonymousSession()
            }
        }
    }
}
