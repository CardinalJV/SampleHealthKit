//
//  Date.swift
//  SampleHealthKit
//
//  Created by Viranaiken Jessy on 21/11/25.
//

import SwiftUI

extension Date {
    static var startOfToday: Date {
        Calendar.current.startOfDay(for: Date())
    }
}
