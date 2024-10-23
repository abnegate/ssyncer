//
//  JSONAppStorage.swift
//  Sshyncer
//
//  Created by Jake Barnby on 23/10/2024.
//

import Foundation

@propertyWrapper
struct JSONAppStorage<T: Codable> {
    let key: String
    let defaultValue: T? = nil
    var storage: UserDefaults = .standard
    
    var wrappedValue: T? {
        get {
            return storage.getObject(T.self, forKey: key) ?? defaultValue
        }
        set {
            storage.setObject(newValue, forKey: key)
        }
    }
}
