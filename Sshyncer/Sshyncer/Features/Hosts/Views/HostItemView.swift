//
//  HostItemView.swift
//  Sshyncer
//
//  Created by Jake Barnby on 21/10/2024.
//

import SwiftUI

struct HostItemView: View {
    @ObservedObject var viewModel: HostListViewModel
    
    let host: Host
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "server.rack")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(6)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.8))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(host.hostname)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(host.user)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(viewModel.backgroundColor(for: host))
                .shadow(color: viewModel.shadow(for: host), radius: 1, x: 0, y: 1)
        )
        #if os(macOS)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separatorColor), lineWidth: 1)
        )
        #else
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
        #endif
        .onHover { hovering in
            viewModel.setHoveredHost(hovering ? host : nil)
        }
    }
}
