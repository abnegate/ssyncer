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
}
