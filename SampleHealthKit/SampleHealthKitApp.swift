//
//  SampleHealthKitApp.swift
//  SampleHealthKit
//
//  Created by Viranaiken Jessy on 20/11/25.
//

import SwiftUI

@main
struct SampleHealthKitApp: App {
    
    @State private var healthController = HealthController()
    @State private var notificationController = NotificationController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await healthController.requestAuthorization()
                    await notificationController.requestAuthorization()
                }
        }
        .environment(self.healthController)
        .environment(self.notificationController)
    }
}
