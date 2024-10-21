//
//  Tunnel.swift
//  Sshyncer
//
//  Created by Jake Barnby on 19/10/2024.
//

import Foundation

enum TunnelType: String, CaseIterable, Identifiable, Codable {
    case local = "Local"
    case remote = "Remote"
    
    var id: String { self.rawValue }
}

struct Tunnel: Identifiable, Codable {
    var id = UUID()
    var port: Int = 0
    var type: TunnelType = .local
    var destinationHost: String = "localhost"
    var destinationPort: Int = 0
}
