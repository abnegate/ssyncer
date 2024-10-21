//
//  ViewModel.swift
//  Sshyncer
//
//  Created by Jake Barnby on 19/10/2024.
//

import SwiftUI

class ViewModel: ObservableObject, Observable {
    @Published var busy: Bool = false
    @Published var error: String? = ""
    
    func whileBusy(_ body: () -> Void) {
        busy.toggle()
        body()
        busy.toggle()
    }
    
    func whileBusy(_ body: () async -> Void) async {
        busy.toggle()
        await body()
        busy.toggle()
    }
    
    func whileBusy<T>(_ body: () -> T) -> T {
        busy.toggle()
        let result = body()
        busy.toggle()
        return result
    }
    
    func whileBusy<T>(_ body: () async -> T) async -> T {
        busy.toggle()
        let result = await body()
        busy.toggle()
        return result
    }
}
