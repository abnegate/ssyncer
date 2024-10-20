//
//  AddHostView.swift
//  Sshyncer
//
//  Created by Jake Barnby on 19/10/2024.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

struct AddHostView: View {
    @StateObject private var viewModel = AddHostViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Text("Add Host")
                .font(.system(size: 13, weight: .bold))
            
            Text("New hosts are synchronized to all devices.")
                .font(.system(size: 11.6))
                .padding(.bottom, 10)
                .padding(.top, 0.1)
            
            Section {
                TextField("Hostname:", text: $viewModel.hostname, prompt: Text("Enter hostname or IP"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Port:", value: $viewModel.port, formatter: NumberFormatter(), prompt: Text("Enter port"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    #if !os(macOS)
                    .keyboardType(.numberPad)
                    #endif
            }
            
            Divider()
                .padding(.vertical, 10)
            
            Section {
                TextField("User:", text: $viewModel.user, prompt: Text("Enter user"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password:", text: $viewModel.password, prompt: Text("Enter password"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                Picker("Key:", selection: $viewModel.selectedKey) {
                    ForEach(viewModel.availableKeys, id: \.id) {
                        Text($0.data.name)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Divider()
                .padding(.vertical, 10)
            
            Section(header: Text("Tags")) {
                VStack {
                    HStack {
                        TextField("Enter tag", text: $viewModel.newTag)
                            .onSubmit {
                                viewModel.addTag()
                            }
                        
                        Button(action: viewModel.addTag) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .buttonStyle(.plain)
                        .disabled(viewModel.newTag.isEmpty)
                    }
                    
                    GeometryReader { geometry in
                        WrapView(tags: $viewModel.tags, availableWidth: geometry.size.width - 40)
                            .padding(10)
                            .environment(viewModel)
                    }
                    .frame(height: calculateWrapViewHeight())
                }
            }
            
            Section {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button("Save") {
                        Task {
                            await viewModel.save()
                        }
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Add Host")
        .padding(20)
    }
    
    private func calculateWrapViewHeight() -> CGFloat {
        return CGFloat(viewModel.tags.count / 2) * 30 + 50
    }
}

public struct WrapView: View {
    @Binding var tags: [String]
    let availableWidth: CGFloat
    
    public init(tags: Binding<[String]>, availableWidth: CGFloat) {
        self._tags = tags
        self.availableWidth = availableWidth
    }
    
    public var body: some View {
        FlexibleView(
            availableWidth: availableWidth,
            data: tags,
            spacing: 10,
            alignment: .leading
        ) { tag in
            TagItemView(tag: tag)
        }
    }
}

struct TagItemView: View {
    @EnvironmentObject var viewModel: AddHostViewModel
    
    let tag: String
    
    var body: some View {
        HStack {
            Text(tag)

            Button(action: { viewModel.removeTag(tag) }) {
                Image(systemName: "xmark")
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(Color.blue.opacity(0.2)))
        .foregroundColor(.blue)
    }
}

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    @State private var totalHeight = CGFloat.zero
    
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(calculateRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                    }
                }
            }
        }
        .frame(maxWidth: availableWidth)
    }
    
    private func calculateRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRowWidth: CGFloat = 0
        
        for element in data {
            let elementWidth = elementSize(for: element).width
            
            if currentRowWidth + elementWidth + spacing > availableWidth {
                rows.append([element])
                currentRowWidth = elementWidth
            } else {
                rows[rows.count - 1].append(element)
                currentRowWidth += elementWidth + spacing
            }
        }
        
        return rows
    }
    
    private func elementSize(for element: Data.Element) -> CGSize {
        #if canImport(UIKit)
        let hostingView = UIHostingController(rootView: content(element))
        #elseif canImport(AppKit)
        let hostingView = NSHostingController(rootView: content(element))
        #endif
        return hostingView.view.intrinsicContentSize
    }
}

#Preview {
    AddHostView()
}
