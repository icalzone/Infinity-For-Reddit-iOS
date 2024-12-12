//
// PostFilterSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB

struct PostFilterSettingsView: View {
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @State private var isCustomizePostFilter = false
    @StateObject var postFilterViewModel: PostFilterViewModel
    private let postFilterDao: PostFilterDao
    @State private var postFilterName: String? = nil
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        postFilterDao = PostFilterDao(dbPool: resolvedDBPool)
        _postFilterViewModel = StateObject(
            wrappedValue: PostFilterViewModel(
                dbPool: resolvedDBPool
            )
        )
    }
    
    var body: some View {
        List() {
            Text("Restart the app to see the changes")
                .foregroundColor(.blue)
                .font(.caption)
            if postFilterViewModel.postFilters.isEmpty {
                Text("No post filters found. Create a new one!")
                    .foregroundColor(.gray)
            } else {
                ForEach(postFilterViewModel.postFilters, id: \.name) { filter in
                    HStack{
                        Text(filter.name)
                        Spacer()
                        
                        Button(action: {}) {
                            SwiftUI.Image(systemName: "info.circle")
                        }
                        .onTapGesture {
                            postFilterName = filter.name
                            isCustomizePostFilter = true
                        }
                        
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            postFilterViewModel.deletePostFilter(filter.name)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            
        }
        .navigationTitle("Post Filter")
        .toolbar {
            Button("", systemImage: "plus") {
                postFilterName = nil
                isCustomizePostFilter = true
            }
        }
        .sheet(isPresented: $isCustomizePostFilter) {
            CustomizePostFilterView($postFilterName)
                
        }
        .onAppear {
            postFilterViewModel.loadPostFilters()
        }
        .environmentObject(postFilterViewModel)
    }
}

