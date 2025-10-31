//
//  watchconnectivitymanager.swift
//  stitchtime
//
//  Created by Nubra Jarial on 31/10/25.
//

import Foundation
import Combine
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    static let shared = WatchConnectivityManager()

    @Published var accelX: Double = 0.0
    @Published var accelY: Double = 0.0
    @Published var accelZ: Double = 0.0

    private override init() {
        super.init()
        activateSession()
    }

    func activateSession() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    // Called when watch sends data
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            print("Received message: \(message)")
            self.handleMessage(message)
        }
    }

    private func handleMessage(_ message: [String : Any]) {
        guard
            let accelX = message["accelX"] as? Double,
            let accelY = message["accelY"] as? Double,
            let accelZ = message["accelZ"] as? Double
        else {
            print("Invalid accelerometer data received")
            return
        }

        // Update published vars (for UI)
        self.accelX = accelX
        self.accelY = accelY
        self.accelZ = accelZ

        // Persist to UserDefaults (or a file/db later)
        let data = ["accelX": accelX, "accelY": accelY, "accelZ": accelZ]
        UserDefaults.standard.set(data, forKey: "lastAccelData")
        print("Stored accelerometer data: \(data)")
    }

    // Required for WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
}
