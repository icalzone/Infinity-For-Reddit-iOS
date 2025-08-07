//
// BackgroundTaskManager.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-06

import Foundation
import BackgroundTasks
import UserNotifications

@MainActor
class BackgroundTasksManager {
    
    // MARK: - Properties
    let taskIdentifier = "com.docilealligator.infinityforreddit"
    
    // MARK: - Singleton
    
    static let shared = BackgroundTasksManager()
    
    // MARK: - Public Methods
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
            let backgroundTask = Task {
                await self.handleAppRefresh(task: task as! BGAppRefreshTask)
            }
            
            // Set the expiration handler. This is called if the task takes too long.
            task.expirationHandler = {
                print("Background Task: Task is expiring, attempting to cancel.")
                backgroundTask.cancel()
            }
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background Task Manager: Successfully scheduled app refresh task.")
        } catch {
            print("Background Task Manager: Could not schedule app refresh task: \(error)")
        }
    }
    
    // MARK: - Task Handling
    private func handleAppRefresh(task: BGAppRefreshTask) async {
        do {
            print("Background Task (async): Starting task.")
            let wasSuccessful = try await performAPICallAndNotify()
            
            task.setTaskCompleted(success: wasSuccessful)
            print("Background Task (async): Task completed with success: \(wasSuccessful).")
            
        } catch is CancellationError {
            print("Background Task (async): Task was cancelled.")
            task.setTaskCompleted(success: false)
        } catch {
            print("Background Task (async): Task failed with error: \(error)")
            task.setTaskCompleted(success: false)
        }
    }
    
    private func performAPICallAndNotify() async throws -> Bool {
        let repository = InboxListingRepository()
        
        let messageWhere = MessageWhere.inbox
        let pathComponents: [String: String] = [:]
        let queries: [String: String] = ["limit": "5"]
        
        let inboxListing = try await repository.fetchInboxListing(
            messageWhere: messageWhere,
            pathComponents: pathComponents,
            queries: queries
        )
        
        try Task.checkCancellation()
        
        if shouldSendNotification(for: inboxListing) {
            print("Background Task (async): Conditions met, sending notification.")
            try await sendLocalNotification(title: "You've got mail!", body: "Check your Reddit inbox for new messages.")
        } else {
            print("Background Task (async): Notification conditions not met.")
        }
        
        return true
    }
    
    // MARK: - Helper Methods
    private func shouldSendNotification(for listing: InboxListing) -> Bool {
        return !(listing.inboxes?.isEmpty ?? true)
    }
    
    private func sendLocalNotification(title: String, body: String) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        try await UNUserNotificationCenter.current().addRequest(request)
        print("Local notification request added successfully via async wrapper.")
    }
}
