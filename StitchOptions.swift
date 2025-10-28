import SwiftUI
import UIKit

struct DataAccess: View {
    @State private var alertMessage: String = ""
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Button("Download Data") {
                if let motionManager = MotionManager.shared {
                    let csvData = motionManager.fetchAllData()
                    let fileName = "accelerometer_data.csv"
                    if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = documentsURL.appendingPathComponent(fileName)
                        do {
                            try csvData.write(to: fileURL, atomically: true, encoding: .utf8)
                            alertMessage = "CSV file saved at:\n\(fileURL.path)"
                        } catch {
                            alertMessage = "Error saving CSV file: \(error)"
                        }
                    }
                    showAlert = true
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Erase Data") {
                MotionManager.shared?.deleteAllData()
                alertMessage = "All data erased."
                showAlert = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Stitch Options"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct DataAccess_Previews: PreviewProvider {
    static var previews: some View {
        DataAccess()
    }
}

// UIViewControllerRepresentable for presenting a share sheet.
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
