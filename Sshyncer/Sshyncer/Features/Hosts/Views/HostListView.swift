//
//  HostsView.swift
//  Sshyncer
//
//  Created by Jake Barnby on 17/10/2024.
//

import SwiftUI

struct HostListView: View {
    @StateObject var viewModel = HostListViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: viewModel.columns(for: geometry.size.width), spacing: 12) {
                    ForEach(viewModel.hosts, id: \.hostname) { host in
                        HostItemView(viewModel: viewModel, host: host)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    HostListView()
}
