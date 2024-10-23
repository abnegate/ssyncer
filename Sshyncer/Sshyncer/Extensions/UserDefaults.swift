//
//  UserDefaults.swift
//  Sshyncer
//
//  Created by Jake Barnby on 23/10/2024.
//

import Foundation

extension UserDefaults {
    func setObject<T: Codable>(_ object: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    func getObject<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = self.data(forKey: key),
           let object = try? JSONDecoder().decode(type, from: data) {
            return object
        }
        return nil
    }
}
