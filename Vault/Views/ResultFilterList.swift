//
//  ResultFilterList.swift
//  Vault
//
//  Created by Austin Vesich on 6/25/24.
//

import SwiftUI

struct ResultFilterList: View {
    
    @Environment(Search.self) var searchModel
    
    var body: some View {
        if !searchModel.activeEngineFilters.isEmpty {
            Divider()
                .padding(.horizontal, 16.0)
                .padding(.bottom, 4.0)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8.0) {
                    ForEach(searchModel.activeEngineFilters) { filter in
                        ResultFilterView(filter: filter)
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
    public var filter: SearchFilter
    
    var body: some View {
        HStack(spacing: 4.0) {
            Image(systemName: filter.iconName)
                .imageScale(.small)
            if let filterName = filter.name {
                Text(filterName)
                    .font(.manrope(12.0))
            }
        }
        .padding(.horizontal, 6.0)
        .padding(.vertical, 4.0)
        .background {
            RoundedRectangle(cornerRadius: 4.0)
                .fill(isHovering ? .white.opacity(0.1) : .clear)
                .animation(.easeOut(duration: 0.1), value: isHovering)
        }
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

#Preview {
    ResultFilterList()
        .environment(Search())
}
