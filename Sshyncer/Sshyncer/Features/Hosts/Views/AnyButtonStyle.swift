//
//  AnyButtonStyle.swift
//  Sshyncer
//
//  Created by Jake Barnby on 21/10/2024.
//

import SwiftUI

struct AnyButtonStyle: PrimitiveButtonStyle {
    private let _makeBody: (PrimitiveButtonStyle.Configuration) -> AnyView
    
    init<S: PrimitiveButtonStyle>(_ style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        _makeBody(configuration)
    }
}
