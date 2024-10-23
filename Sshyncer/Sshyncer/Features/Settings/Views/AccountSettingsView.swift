//
//  AccountSettingsView.swift
//  Sshyncer
//
//  Created by Jake Barnby on 22/10/2024.
//

import SwiftUI

struct AccountSettingsView: View {
    @StateObject var viewModel = AccountSettingsViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                profileImageView()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                
                Text(viewModel.accountName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                
                Text(viewModel.accountEmail)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if viewModel.isLoggedIn {
                    HStack {
                        Text("Multi-Factor Authentication:")
                            .font(.subheadline)
                        Spacer()
                        Text(viewModel.isMFAEnabled ? "Enabled" : "Disabled")
                            .font(.subheadline)
                            .foregroundColor(viewModel.isMFAEnabled ? .green : .red)
                    }
                    .padding(.horizontal)
                
                    Spacer()
                
                    Button(action: {
                        viewModel.logOut()
                    }) {
                        Text("Log out")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .padding()
            
            if !viewModel.isLoggedIn {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Sign in buttons
                    VStack(spacing: 16) {
                        signInButton("Sign in with Apple", icon: "applelogo", action: viewModel.logInWithApple)
                        signInButton("Sign in with GitHub", icon: "logo.github", action: viewModel.logInWithGitHub)
                        signInButton("Sign in with Google", icon: "globe", action: viewModel.logInWithGoogle)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
    
    // Profile Image View based on login state
    @ViewBuilder
    private func profileImageView() -> some View {
        if viewModel.isLoggedIn, let url = viewModel.profileImageUrl {
            // Fetch and display actual image
            AsyncImage(url: url) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
        } else {
            // Placeholder image
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
        }
    }
    
    // Sign in button factory
    private func signInButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

#Preview {
    AccountSettingsView()
}
