//
//  AddHostViewModel.swift
//  Sshyncer
//
//  Created by Jake Barnby on 19/10/2024.
//

import SwiftUI
import Appwrite



class HostAddViewModel: ViewModel {
    private var appwrite = Appwrite.shared
    
    @Published var hostname: String = ""
    @Published var port: Int = 22
    @Published var user: String = "root"
    @Published var password: String = ""
    @Published var selectedKey: Key? = nil
    @Published var tunnels: [Tunnel] = []
    @Published var tags: [String] = []
    @Published var newTag: String = ""

    @Published var availableKeys: [Document<Key>] = []
    
    var isValid: Bool {
        return hostname.isValidHostnameOrIP()
            && port.isValidPortNumber()
            && !user.isEmpty
            && (!password.isEmpty || selectedKey != nil)
    }
    
    var saveButtonStyle: AnyButtonStyle {
        isValid
            ? AnyButtonStyle(BorderedProminentButtonStyle())
            : AnyButtonStyle(DefaultButtonStyle())
    }
    
    func addTag() {
        let trimmed = newTag.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty && !tags.contains(trimmed) {
            tags.append(trimmed)
        }
        newTag = ""
    }
    
    func removeTag(_ tag: String) {
        tags.removeAll(where: { $0 == tag })
    }
    
    func load() async {
        do {            
            let keys = try await appwrite.listKeys()
            
            availableKeys = keys.documents
        } catch {
            self.error = "Error loading keys: \(error)"
        }
    }
    
    func save() async {
        do {
            _ = try await appwrite.createHost(Host(
                hostname: hostname,
                port: port,
                user: user,
                password: password,
                key: selectedKey,
                tunnels: tunnels
            ))
        } catch {
            self.error = error.localizedDescription
        }
    }
}
