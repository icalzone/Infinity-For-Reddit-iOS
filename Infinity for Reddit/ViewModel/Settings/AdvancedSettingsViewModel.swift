//
//  AdvancedSettingsViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-04.
//

import Foundation
import Swinject
import GRDB

@MainActor
final class AdvancedSettingsViewModel: ObservableObject {
    private let container: Container
    private let dbPool: DatabasePool
    private let subredditDao: SubredditDao
    private let userDao: UserDao
    private let postHistoryDao: PostHistoryDao
    private let customThemeDao: CustomThemeDao
    
    init(container: Container = DependencyManager.shared.container) {
        self.container = container
        guard let resolvedPool = container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.dbPool = resolvedPool
        self.subredditDao = SubredditDao(dbPool: resolvedPool)
        self.userDao = UserDao(dbPool: resolvedPool)
        self.postHistoryDao = PostHistoryDao(dbPool: resolvedPool)
        self.customThemeDao = CustomThemeDao(dbPool: resolvedPool)
    }
    
    func deleteAllSubreddits() async throws {
        try await subredditDao.deleteAllSubreddits()
    }
    
    func deleteAllUsers() async throws {
        try await userDao.deleteAllUsers()
    }
    
    func deleteAllSortTypes() async {
        
    }
    
    func deleteAllPostLayouts() async {
        
    }
    
    func deleteAllThemes() async throws {
        try await customThemeDao.deleteAllCustomThemes()
    }
    
    func deleteFrontPagePositions() async {
        
    }
    
    func deleteReadPosts() async throws {
        try await postHistoryDao.deleteAllReadPosts()
    }
    
    func deleteLegacySettings() async {
        
    }
    
    func resetAllSettings() async {
        
    }
    
    func backupSettings() async throws {

    }
    
    func restoreSettings() async throws {

    }
    
    func openCrashReports() {

    }
}
