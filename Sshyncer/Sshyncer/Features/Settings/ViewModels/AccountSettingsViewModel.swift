//
//  AccountSettingsViewModel.swift
//  Sshyncer
//
//  Created by Jake Barnby on 23/10/2024.
//

import SwiftUI

class AccountSettingsViewModel: ViewModel {
    private var appwrite = Cloud.shared
    
    @Published var isLoggedIn: Bool
    @Published var isMFAEnabled: Bool
    @Published var profileImageUrl: String?
    @Published var accountName: String
    @Published var accountEmail: String
    
    override init() {
        isLoggedIn = appwrite.user?.email.isEmpty == false
        isMFAEnabled = appwrite.user?.mfa ?? false
        profileImageUrl = appwrite.user?.prefs.data.avatarUrl
        accountName = appwrite.user?.name ?? "John Doe"
        accountEmail = appwrite.user?.email ?? "john@doe.com"
        
        super.init()
    }
    
    func logInWithApple() async {
        do {
            if try await appwrite.createOAuth2Session(.apple) {
                print("Logged in")
            } else {
                self.error = "Failed to login with Apple"
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func logInWithGitHub() async {
        do {
            if try await appwrite.createOAuth2Session(.github) {
                print("Logged in")
            } else {
                self.error = "Failed to login with Apple"
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func logInWithGoogle() {
    }
    
    func logOut() async {
        do {
            _ = try await appwrite.deleteSession()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
