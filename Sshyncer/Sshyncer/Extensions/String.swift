//
//  String.swift
//  Sshyncer
//
//  Created by Jake Barnby on 21/10/2024.
//

import Foundation

extension String {
    
    /// Check if input is either a valid hostname or IP
    func isValidHostnameOrIP() -> Bool {
        return isValidHostname() || isValidIP()
    }
    
    /// Check if the string is a valid hostname
    func isValidHostname() -> Bool {
        let hostnameRegex = "^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z]{2,})+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", hostnameRegex)
        return predicate.evaluate(with: self) && self.count <= 255
    }
    
    /// Check if the string is a valid IP address (IPv4 or IPv6)
    func isValidIP() -> Bool {
        return isValidIPv4() || isValidIPv6()
    }
    
    /// Check if the string is a valid IPv4 address
    func isValidIPv4() -> Bool {
        let ipv4Regex = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", ipv4Regex)
        return predicate.evaluate(with: self)
    }
    
    /// Check if the string is a valid IPv6 address
    func isValidIPv6() -> Bool {
        let ipv6Regex = "^([0-9a-fA-F]{1,4}:){7}([0-9a-fA-F]{1,4}|:)$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", ipv6Regex)
        return predicate.evaluate(with: self)
    }
}
