//
//  WorkoutSessionManager.swift
//  stitchtime
//
//  Created by Nubra Jarial on 31/10/25.
//


import Foundation
import HealthKit

final class WorkoutSessionManager: NSObject{
    
    static let shared = WorkoutSessionManager()
    
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    
    private override init() {
        super.init()
    }
    
    // MARK: - Request Permission
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let typesToShare: Set = [HKObjectType.workoutType()]
        healthStore.requestAuthorization(toShare: typesToShare, read: []) { success, error in
            if success {
                print("✅ HealthKit authorized")
            } else {
                print("❌ HealthKit authorization failed: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }
    
    // MARK: - Start Workout Session
    func startSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .unknown
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
                       
            builder = session?.associatedWorkoutBuilder()
            session?.delegate = self
            builder?.delegate = self
            
            session?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date()) { success, error in
                if success {
                    print("🏃‍♀️ Workout session started")
                    // Start your MotionManager here
                    MotionManager.shared?.startAccelerometerUpdates()
                } else {
                    print("❌ Failed to begin collection: \(error?.localizedDescription ?? "unknown")")
                }
            }
        } catch {
            print("❌ Failed to start session: \(error)")
        }
    }
    
    // MARK: - Stop Workout Session
    func stopSession() {
        MotionManager.shared?.stopAccelerometerUpdates()
        
        session?.end()
        builder?.endCollection(withEnd: Date()) { _, _ in
            self.builder?.finishWorkout { workout, error in
                print("🏁 Workout ended: \(String(describing: workout))")
            }
        }
        session = nil
        builder = nil
    }
}

// MARK: - HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate
extension WorkoutSessionManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout state: \(toState.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout error: \(error.localizedDescription)")
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}
}
