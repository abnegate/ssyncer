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
    let defaultValue: T?
    var storage: UserDefaults = .standard
    
    private var value: T?
    
    init(key: String, defaultValue: T? = nil, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
        self.value = storage.getObject(T.self, forKey: key) ?? defaultValue
    }
    
    var wrappedValue: T? {
        get {
            return storage.getObject(T.self, forKey: key) ?? defaultValue
        }
        set {
            value = newValue
            storage.setObject(newValue, forKey: key)
        }
    }
}
