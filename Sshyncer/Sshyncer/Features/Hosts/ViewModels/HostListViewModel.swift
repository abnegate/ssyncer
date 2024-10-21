//
//  HostListViewModel.swift
//  Sshyncer
//
//  Created by Jake Barnby on 21/10/2024.
//

import Appwrite
import SwiftUI

class HostListViewModel: ViewModel {
    @Published var hosts: [Host] = [
        Host(hostname: "192.168.4.107", port: 22, user: "jake", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "arr.jakebarnby.com", port: 22, user: "root", password: "password"),
        Host(hostname: "tesr.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "test2.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "test3.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "test4.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "test5.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "test6.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "test7.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "test8.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "test9.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro")),
        Host(hostname: "test10.app.com", port: 22, user: "root", key: Key(id: ID.unique(), name: "Jakes macbook pro"))
    ]
    
    @Published var hoveredHostID: String?
    
    /// Calculate dynamic columns based on available width
    func columns(for width: CGFloat) -> [GridItem] {
        let minItemWidth: CGFloat = 250
        let spacing: CGFloat = 16
        let numberOfColumns = Int((width + spacing) / (minItemWidth + spacing))
        
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: min(max(numberOfColumns, 1), 4))
    }
    
    /// Check if a host is currently being hovered
    func isHostHovered(_ host: Host) -> Bool {
        return hoveredHostID == host.hostname
    }
    
    /// Set the hovered host based on its hostname
    func setHoveredHost(_ host: Host?) {
        hoveredHostID = host?.hostname
    }
    
//    /// Determine background color
//    func backgroundColor(for host: Host) -> Color {
//        return isHostHovered(host) ? Color.white.opacity(0.05) : Color.white.opacity(0.4)
//    }
//    
//    /// Determine shadow for host
//    func shadow(for host: Host) -> Color {
//        return isHostHovered(host) ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2)
//    }
    
    /// Determine background color
    func backgroundColor(for host: Host) -> Color {
        return isHostHovered(host) ? Color("itemBackgroundHover") : Color("itemBackgroundDefault")
    }
    
    /// Determine shadow for host
    func shadow(for host: Host) -> Color {
        return isHostHovered(host) ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2)
    }
}
