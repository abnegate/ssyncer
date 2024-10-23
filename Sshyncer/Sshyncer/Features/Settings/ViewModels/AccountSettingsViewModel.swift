//
//  AccountSettingsViewModel.swift
//  Sshyncer
//
//  Created by Jake Barnby on 23/10/2024.
//

import SwiftUI

class AccountSettingsViewModel: ViewModel {
    @Published var isLoggedIn: Bool = false
    @Published var isMFAEnabled: Bool = false
    @Published var profileImageUrl: URL? = nil
    @Published var accountName: String = "John Doe"
    @Published var accountEmail: String = "johndoe@example.com"
    
    override init() {
        super.init()
    }
    
    func logInWithApple() {
    }
    
    func logInWithGitHub() {
    }
    
    func logInWithGoogle() {
    }
    
    func logOut() {
    }
}
