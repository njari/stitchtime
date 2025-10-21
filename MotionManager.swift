import SwiftUI
import CoreMotion

final class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var accelX: Double = 0.0
    @Published var accelY: Double = 0.0
    @Published var accelZ: Double = 0.0
    @Published var gyroX: Double = 0.0
    @Published var gyroY: Double = 0.0
    @Published var gyroZ: Double = 0.0

    init() {
        // update intervals (every 0.1s)
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
    }

    func startUpdates() {
        // Accelerometer updates
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
                guard let data, let self else { return }
                self.accelX = data.acceleration.x
                self.accelY = data.acceleration.y
                self.accelZ = data.acceleration.z
            }
        }

        // Gyroscope updates
        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates(to: .main) { [weak self] data, _ in
                guard let data, let self else { return }
                self.gyroX = data.rotationRate.x
                self.gyroY = data.rotationRate.y
                self.gyroZ = data.rotationRate.z
            }
        }
    }

    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }
}
