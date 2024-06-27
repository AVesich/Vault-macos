//
//  ResultFilterList.swift
//  Vault
//
//  Created by Austin Vesich on 6/25/24.
//

import SwiftUI

struct ResultFilterList: View {
    
    @Environment(Search.self) var searchModel
    @State private var selectedIconIndex: Int?
    
    var body: some View {
        if !searchModel.activeEngineFilters.isEmpty {
            Divider()
                .padding(.horizontal, 16.0)
                .padding(.bottom, 4.0)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8.0) {
                    ForEach(Array(searchModel.activeEngineFilters.enumerated()), id: \.offset) { (i, filter) in
                        ResultFilterView(selectedIconIndex: $selectedIconIndex,
                                         selectionIndex: i,
                                         filter: filter)
                    }
                }
                .padding(.horizontal, 16.0)
            }
            .padding(.bottom, 4.0)
            .frame(height: 36.0)
        }
    }
}

struct ResultFilterView: View {
    
    @State private var isHovering: Bool = false
    @Binding public var selectedIconIndex: Int?
    public var selectionIndex: Int
    public var filter: SearchFilter
    private var backgroundColor: Color {
        let selected = selectedIconIndex == selectionIndex
        if selected || isHovering {
            return (selected && isHovering) ? .white.opacity(0.2) : .white.opacity(0.1)
        }
        return .clear
    }
    
    var body: some View {
        HStack(spacing: 4.0) {
            Image(systemName: filter.iconName)
                .imageScale(.medium)
            Text(filter.name)
                .font(.manrope(12.0))
        }
        .padding(.horizontal, 6.0)
        .padding(.vertical, 4.0)
        .foregroundColor(.secondary)
        .background {
            RoundedRectangle(cornerRadius: 4.0)
                .fill(backgroundColor)
                .animation(.easeOut(duration: 0.1), value: isHovering)
                .animation(.easeOut(duration: 0.1), value: selectedIconIndex)
        }
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture {
            selectedIconIndex = selectedIconIndex == selectionIndex ? nil : selectionIndex
        }
    }
}

#Preview {
    ResultFilterList()
        .environment(Search())
}
