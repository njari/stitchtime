import SwiftUI

struct WatchStartScreen: View {
    let motionManager = MotionManager()
    @State private var isRecording = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 15) {
                    Button(isRecording ? "Stop" : "Start") {
                        if isRecording {
                            motionManager.stopUpdates()
                        } else {
                            motionManager.startUpdates()
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

                    Spacer()
                }
                .padding()
            }
        }
    }
}

