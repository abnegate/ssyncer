//
//  TunnelItemView.swift
//  Sshyncer
//
//  Created by Jake Barnby on 20/10/2024.
//

import SwiftUI

struct TunnelItemView: View {
    @Binding var tunnel: Tunnel
    
    var body: some View {
        VStack {
            HStack {
                Picker("", selection: $tunnel.type) {
                    ForEach(TunnelType.allCases) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(.automatic)
                
                TextField("Port:", value: $tunnel.port, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    #if !os(macOS)
                    .keyboardType(.numberPad)
                    #endif
            }
            
            TextField("Destination Host:", text: $tunnel.destinationHost)
            
            TextField("Destination Port:", value: $tunnel.destinationPort, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                #if !os(macOS)
                .keyboardType(.numberPad)
                #endif
        }
    }
}
