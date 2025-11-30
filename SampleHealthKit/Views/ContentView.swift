//
//  ContentView.swift
//  SampleHealthKit
//
//  Created by Viranaiken Jessy on 20/11/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(HealthController.self) private var healthController
    @Environment(NotificationController.self) private var notificationController
    
    var body: some View {
        VStack {
            if healthController.stepCountOfToday != 0 {
                Text("Steps: \(healthController.stepCountOfToday)")
            }
            if healthController.activeEnergyBurnedOfToday != 0 {
                Text("Calories: \(healthController.activeEnergyBurnedOfToday)")
            }
            Button("Launch a notification") {
                Task {
//                    if await notificationController.verifyAuthorizationStatus() {
//                        await notificationController.badgeInNotification()
//                        await notificationController.badgeOutNotification() 
//                    }
                    if await notificationController.authorizationStatus() == .authorized {
                        
                    }
                }
            }
        }
        .task {
            await healthController.fetchStepCountOfToday()
            await healthController.fetchActiveEnergyBurnedOfToday()
        }
    }
}

#Preview {
    
    @Previewable var healthController = HealthController()
    
    ContentView()
        .environment(healthController)
}
