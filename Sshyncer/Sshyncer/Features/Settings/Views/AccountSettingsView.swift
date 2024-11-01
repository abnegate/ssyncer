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
            VStack(spacing: 8) {
                HStack {
                    profileImageView()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.accountName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(viewModel.accountEmail)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom)
                
                if viewModel.isLoggedIn {
                    VStack {
                        Text("Connected Accounts")
                            .bold()
                        
                        ForEach(viewModel.accountTypes, id: \.self) { type in
                            HStack {
                                Text(type)
                                
                                Spacer()
                                
                                Toggle(isOn: $viewModel.isMFAEnabled) {}
                                    .toggleStyle(.switch)
                                    .onChange(of: viewModel.isMFAEnabled, initial: viewModel.isMFAEnabled) { old, new in
                                        Task { await viewModel.setMFAEnabled(new, type: type) }
                                    }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("itemBackgroundDefault"))
                            .shadow(color: .gray.opacity(0.2), radius: 1, x: 0, y: 1)
                    )
                    #if os(macOS)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separatorColor), lineWidth: 1)
                    )
                    #else
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                    #endif
                    
                    VStack {
                        Text("Multi-Factor Authentication")
                            .bold()

                        
                        ForEach(viewModel.mfaTypes, id: \.self) { type in
                            HStack {
                                Text(type)
                                
                                Spacer()
                                
                                Toggle(isOn: $viewModel.isMFAEnabled) {}
                                    .toggleStyle(.switch)
                                    .onChange(of: viewModel.isMFAEnabled, initial: viewModel.isMFAEnabled) { old, new in
                                        Task { await viewModel.setMFAEnabled(new, type: type) }
                                    }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("itemBackgroundDefault"))
                            .shadow(color: .gray.opacity(0.2), radius: 1, x: 0, y: 1)
                    )
                    #if os(macOS)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separatorColor), lineWidth: 1)
                    )
                    #else
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                    #endif
                
                    Button(action: { Task { await viewModel.logOut() } }) {
                        Text("Log out")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(maxWidth: 250, alignment: .top)
            .padding()
            
            if !viewModel.isLoggedIn {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        signInButton("Sign in with Apple", icon: "applelogo", action: viewModel.logInWithApple)
                        signInButton("Sign in with GitHub", icon: "github", action: viewModel.logInWithGitHub)
                        signInButton("Sign in with Google", icon: "globe", action: viewModel.logInWithGoogle)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func profileImageView() -> some View {
        if viewModel.isLoggedIn, let url = viewModel.profileImageUrl {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
        }
    }
    
    private func signInButton(_ title: String, icon: String, action: @escaping () async -> Void) -> some View {
        Button(action: { Task { await action() } }) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
        }
    }
}

#Preview {
    AccountSettingsView()
}
