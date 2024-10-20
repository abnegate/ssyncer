//
//  Host.swift
//  Sshyncer
//
//  Created by Jake Barnby on 19/10/2024.
//

struct Host : Codable {
    var hostname: String = ""
    var port: Int = 22
    var user: String = ""
    var password: String = ""
    var key: Key? = nil
    var tunnels: [Tunnel] = []
    var tags: [String] = []
}
