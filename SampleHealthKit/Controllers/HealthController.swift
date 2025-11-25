//
//  HealthKitController.swift
//  SampleHealthKit
//
//  Created by Viranaiken Jessy on 20/11/25.
//

import HealthKit

@Observable class HealthController {
    // Initialisation of HKHealthStore
    @ObservationIgnored private var healthStore: HKHealthStore? = nil
    // Setting Set of QuantityType
    @ObservationIgnored private var allTypes: Set<HKQuantityType>? = nil
    // Parameter instance of step data
    @ObservationIgnored private var stepCountAnchor: HKQueryAnchor? = nil
    var stepCountOfToday: Int = 0
    // Parameter instance of calories data
    @ObservationIgnored private var activeEnergyBurnedAnchor: HKQueryAnchor? = nil
    var activeEnergyBurnedOfToday: Int = 0
    // Init
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
            self.allTypes = [
                HKQuantityType(.stepCount),
                HKQuantityType(.pushCount),
                HKQuantityType(.bloodGlucose),
                HKQuantityType(.basalEnergyBurned),
                HKQuantityType(.activeEnergyBurned)
            ]
        }
    }
    // Request authorization
    func requestAuthorization() async {
        do {
            if let types = self.allTypes, let store = self.healthStore {
                try await store.requestAuthorization(toShare: types, read: types)
            }
        } catch {
            print("Error during fetching HealthKit data: \(error.localizedDescription)")
            return
        }
    }
    // Fetch steps
    func fetchStepCountOfToday() async {
        /// Define the type of quantity that will be observed
        let type = HKQuantityType(.stepCount)
        /// Set the predicate to give boundaries for the type that will be fetched, in this case just for today
        let predicate = HKQuery.predicateForSamples(withStart: .startOfToday, end: Date.now)
        /// Init anchor object that will observe update
        let descriptor = HKAnchoredObjectQueryDescriptor(predicates: [.quantitySample(type: type, predicate: predicate)], anchor: self.stepCountAnchor)
        /// Init the query object that will fetch the type
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, results, error in
            /// Guard to verify if there are a result and no error
            guard let results = results, error == nil else { return }
            /// Convert the result to the int readable for the UI
            if let sum = results.sumQuantity() {
                self.stepCountOfToday = Int(sum.doubleValue(for: .count()))
            }
        }
        /// Init the observation process
        if let store = self.healthStore {
            do {
                /// Init the results object
                let results = descriptor.results(for: store)
                /// Launch the observation
                for try await result in results {
                    /// For every change, re-init a new anchor to continue the observation process
                    self.stepCountAnchor = result.newAnchor
                    /// For each update, execute the query request to get new steps and update steps amount
                    store.execute(query)
                }
            } catch {
                print("HealthKit error :", error)
            }
        }
    }
    /* In progress */
    //    func fetchActiveEnergyBurnedOfToday() async {
    //        let type = HKQuantityType(.activeEnergyBurned)
    //        let predicate = HKQuery.predicateForSamples(withStart: .startOfToday, end: Date.now)
    //        let descriptor = HKAnchoredObjectQueryDescriptor(predicates: [.quantitySample(type: type, predicate: predicate)], anchor: self.activeEnergyBurnedAnchor)
    //        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, results, error in
    //            guard let results = results, error == nil else {
    //                return
    //            }
    //            if let sum = results.sumQuantity() {
    //                self.activeEnergyBurnedOfToday = Int(sum.doubleValue(for: .joule()))
    //            }
    //        }
    //
    //        if let store = self.healthStore {
    //            store.execute(query)
    //            do {
    //                let results = descriptor.results(for: store)
    //                for try await result in results {
    //                    self.activeEnergyBurnedAnchor = result.newAnchor
    //                    store.execute(query)
    //                }
    //            } catch {
    //                print("HealthKit error during fetching calories amount:", error)
    //            }
    //        }
    //    }
    /* - */
}
