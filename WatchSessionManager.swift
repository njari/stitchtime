import WatchConnectivity
import Foundation

class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchSessionManager()
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated: \(activationState.rawValue), error: \(String(describing: error))")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session becoming inactive if needed
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    
    // Receive messages from the watch containing accelerometer data
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Received message from watch: \(message)")
        if let openDataAccess = message["openDataAccess"] as? Bool, openDataAccess == true {
            // Post a notification so that the phone app can open the DataAccess screen.
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("openDataAccess"), object: nil)
            }
        } else if let x = message["accelX"] as? Double,
                  let y = message["accelY"] as? Double,
                  let z = message["accelZ"] as? Double {
            DispatchQueue.main.async {
                MotionManager.shared?.insertAccelerometerData(x: x, y: y, z: z)
            }
        }
    }
}
