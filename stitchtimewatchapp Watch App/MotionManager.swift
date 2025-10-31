import Foundation
import CoreMotion
import SQLite3
import Combine
import WatchConnectivity

class MotionManager: NSObject, ObservableObject {
    static var shared: MotionManager?
    private let motion = CMMotionManager()
    
    @Published var accelX: Double = 0.0
    @Published var accelY: Double = 0.0
    @Published var accelZ: Double = 0.0
    
    var db: OpaquePointer?
    
    // MARK: - Init
    override init() {
        super.init()
        MotionManager.shared = self
//        openDatabase()
//        createTable()
        setupWCSession() // ✅ Activate once here
    }
    
    // MARK: - Setup WCSession
    private func setupWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // MARK: - Accelerometer
    func startAccelerometerUpdates() {
        guard motion.isAccelerometerAvailable else {
            print("Accelerometer is not available.")
            return
        }
        
        motion.accelerometerUpdateInterval = 1.0
        motion.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }
            
            self.accelX = data.acceleration.x
            self.accelY = data.acceleration.y
            self.accelZ = data.acceleration.z
            
            // Send to iPhone
            self.sendDataToPhone()
        }
    }
    
    func stopAccelerometerUpdates() {
        motion.stopAccelerometerUpdates()
    }
    
    // MARK: - Send to iPhone
    private func sendDataToPhone() {
        let session = WCSession.default
            session.sendMessage(
                ["accelX": accelX, "accelY": accelY, "accelZ": accelZ],
                replyHandler: nil,
                errorHandler: { error in
                    print("Error sending message: \(error.localizedDescription)")
                }
            )
    }
    
}



#if os(watchOS)
extension MotionManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated on Watch: \(activationState.rawValue)")
    }
}
#endif
