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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await healthController.requestAuthorization()
                }
        }
        .environment(self.healthController)
    }
}
