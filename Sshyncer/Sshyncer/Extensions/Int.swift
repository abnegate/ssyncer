//
//  Int.swift
//  Sshyncer
//
//  Created by Jake Barnby on 21/10/2024.
//

extension Int {
    
    /// Check if the int is a valid port number
    func isValidPortNumber() -> Bool {
        return self >= 0 && self <= 65535
    }
}
