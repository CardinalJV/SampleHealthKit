//
//  NotificationController.swift
//  SampleHealthKit
//
//  Created by Viranaiken Jessy on 26/11/25.
//

import UserNotifications

@Observable class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    let center = UNUserNotificationCenter.current()
    
    func verifyAuthorizationStatus() async -> Bool {
        let settings = await center.notificationSettings()
        if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
            return true
        } else {
            return false
        }
    }
    
    func requestAuthorization() async {
        do {
            try await center.requestAuthorization(options: [.alert, .sound, .badge, .provisional])
        } catch {
            print("Error during requestAuthorization: \(error.localizedDescription)")
        }
    }
    
    func launchNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "My notification title"
        content.body = "My notification body"
        let notification = UNNotificationRequest(identifier: "com.example.mynotification", content: content, trigger: nil)
        do {
            try await center.add(notification)
        } catch {
            print("Error during launching notification: \(error.localizedDescription)")
        }
    }
}
