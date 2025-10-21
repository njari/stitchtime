import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var accelerometerData: CMAccelerometerData?
    @Published var gyroData: CMGyroData?
    
    private var recordTimer: Timer?
    var csvLines: [String] = []
    
    init() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
    }
    
    func startUpdates() {
        // Clear previous data and add CSV header.
        csvLines = ["timestamp,ax,ay,az,gx,gy,gz"]
        
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates()
        }
        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates()
        }
        // Start a timer to sample sensor data every 0.1 second.
        recordTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self,
                  let accel = self.motionManager.accelerometerData,
                  let gyro = self.motionManager.gyroData else { return }
            let timestamp = Date().timeIntervalSince1970
            let line = String(format: "%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f",
                              timestamp,
                              accel.acceleration.x, accel.acceleration.y, accel.acceleration.z,
                              gyro.rotationRate.x, gyro.rotationRate.y, gyro.rotationRate.z)
            self.csvLines.append(line)
        }
    }
    
    func stopUpdates() -> URL? {
        recordTimer?.invalidate()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        return dumpCSVToFile()
    }
    
    private func dumpCSVToFile() -> URL? {
        let csvString = csvLines.joined(separator: "\n")
        let fm = FileManager.default
        if let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileUrl = docUrl.appendingPathComponent("sensor_data.csv")
            do {
                try csvString.write(to: fileUrl, atomically: true, encoding: .utf8)
                return fileUrl
            } catch {
                print("Error writing CSV: \(error)")
                return nil
            }
        }
        return nil
    }
}

struct WatchStartScreen: View {
    @State private var isRecording = false
    @State private var csvFileURL: URL? = nil
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background using primary color
                AppColors.primary
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    if isRecording {
                        PrimaryButton(title: "Stop")
                            .onTapGesture {
                                if let fileURL = motionManager.stopUpdates() {
                                    csvFileURL = fileURL
                                }
                                isRecording = false
                            }
                    } else {
                        PrimaryButton(title: "Start")
                            .onTapGesture {
                                motionManager.startUpdates()
                                isRecording = true
                                csvFileURL = nil
                            }
                    }
                    
                    if let url = csvFileURL {
                        Text("CSV saved at:")
                            .font(.caption)
                            .foregroundColor(.white)
                        Text(url.lastPathComponent)
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct WatchStartScreen_Previews: PreviewProvider {
    static var previews: some View {
        WatchStartScreen()
    }
}
