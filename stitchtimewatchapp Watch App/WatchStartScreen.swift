//
//  WatchStartScreen.swift
//  stitchtime
//
//  Created by Nubra Jarial on 21/10/25.
//


struct WatchStartScreen: View {
    @State private var isRecording = false
    @State private var csvFileURL: URL? = nil
    @StateObject private var motionManager = MotionManager()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Button(isRecording ? "Stop" : "Start") {
                        if isRecording {
                            if let fileURL = motionManager.stopUpdates() {
                                csvFileURL = fileURL
                            }
                        } else {
                            motionManager.startUpdates()
                            csvFileURL = nil
                        }
                        isRecording.toggle()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)

                    if let url = csvFileURL {
                        VStack {
                            Text("CSV saved at:")
                                .font(.caption)
                            Text(url.lastPathComponent)
                                .font(.caption2)
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
