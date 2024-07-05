//
//  ResultFilterList.swift
//  Vault
//
//  Created by Austin Vesich on 6/25/24.
//

import SwiftUI
import SwiftData

struct ResultFilterList: View {
    
    @Environment(GlobalSearch.self) var searchModel
    
    var body: some View {
        if let searchMode = searchModel.activeMode,
           !searchMode.filters.isEmpty {
            Divider()
                .padding(.horizontal, 16.0)
                .padding(.bottom, 4.0)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8.0) {
                    ForEach(Array(searchMode.filters.enumerated()), id: \.offset) { (i, filter) in
                        ResultFilterView(selectedIconIndices: searchModel.filterBinding,
                                         selectionDefault: searchMode.defaultFilterIndex,
                                         selectionIndex: i,
                                         allowsMultipleSelection: searchMode.allowMultipleFilterSelections,
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
    @Binding public var selectedIconIndices: Set<Int>
    public var selectionDefault: Int?
    public var selectionIndex: Int
    public var allowsMultipleSelection: Bool
    public var filter: SearchFilter
    private var selected: Bool {
        selectedIconIndices.contains(selectionIndex)
    }
    private var backgroundColor: Color {
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
                .animation(.easeOut(duration: 0.1), value: selectedIconIndices)
        }
        .onHover { hovering in
            isHovering = hovering
        }
        .onChange(of: selected) { // Handle being defaulted back to/removed when no mult. selection
            if selected { // We are now selected
                filter.selectAction()
            } else { // We were deselected
                if let deselectAction = filter.deselectAction {
                    deselectAction()
                }
            }
        }
        .onTapGesture {
            if selectedIconIndices.contains(selectionIndex) {
                if let deselectAction = filter.deselectAction {
                    deselectAction()
                }
                selectedIconIndices.remove(selectionIndex)
                if selectedIconIndices.isEmpty, let selectionDefault {
                    selectedIconIndices.insert(selectionDefault)
                }
            } else {
                filter.selectAction()
                if !allowsMultipleSelection {
                    selectedIconIndices.removeAll()
                }
                selectedIconIndices.insert(selectionIndex)
            }
        }
    }
}

#Preview {
    let dummyContainer = try! ModelContainer(for: Search.self)

    ResultFilterList()
        .environment(GlobalSearch(modelContext: dummyContainer.mainContext))
}
