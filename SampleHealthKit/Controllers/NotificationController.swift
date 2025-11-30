//
//  NotificationController.swift
//  SampleHealthKit
//
//  Created by Viranaiken Jessy on 26/11/25.
//

import UserNotifications

@Observable class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    
    let center = UNUserNotificationCenter.current()
    
    func authorizationStatus() async {
        let settings = await center.notificationSettings()
        let status = settings.authorizationStatus
        switch status {
        case .authorized:
            
        default:
            break
        }
    }
    
    private func requestAuthorization() async {
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
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let notification = UNNotificationRequest(identifier: "com.example.mynotification", content: content, trigger: trigger)
        do {
            try await center.add(notification)
        } catch {
            print("Error during launching notification: \(error.localizedDescription)")
        }
    }
    
    func badgeInNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "Apple developer academy"
        content.body = "Badge-in"
        var date = DateComponents()
        date.hour = 14
        date.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "com.example.mynotification", content: content, trigger: trigger)
        do {
            try await center.add(request)
        } catch {
            print("error during launching notification: \(error.localizedDescription)")
        }
    }
    
    func badgeOutNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "Apple developer academy"
        content.body = "Badge-out"
        var date = DateComponents()
        date.hour = 18
        date.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "com.example.mynotification", content: content, trigger: trigger)
        do {
            try await center.add(request)
        } catch {
            print("error during launching notification: \(error.localizedDescription)")
        }
    }
}
