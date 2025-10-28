import SwiftUI
import WatchConnectivity

struct WatchStartScreen: View {
    @StateObject var motionManager = MotionManager()
    @State private var isRecording = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 15) {
                        Button(isRecording ? "Stop" : "Start") {
                            if isRecording {
                                motionManager.stopAccelerometerUpdates()
                            } else {
                                motionManager.startAccelerometerUpdates()
                            }
                            isRecording.toggle()
                        }
                        .font(.headline)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)

                        VStack(spacing: 5) {
                            Text("Accelerometer")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("x: \(motionManager.accelX, specifier: "%.2f")")
                                .foregroundColor(.white)
                            Text("y: \(motionManager.accelY, specifier: "%.2f")")
                                .foregroundColor(.white)
                            Text("z: \(motionManager.accelZ, specifier: "%.2f")")
                                .foregroundColor(.white)
                        }
                        
                        Button("Access Data on Phone") {
                            if WCSession.default.activationState == .activated {
                                WCSession.default.sendMessage(["openDataAccess": true], replyHandler: nil, errorHandler: { error in
                                    print("Error sending message: \(error)")
                                })
                            } else {
                                print("WCSession not activated")
                            }
                        }
                        .font(.caption)
                        .padding(5)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                    .padding()
                }
            }
        }
    }
}
