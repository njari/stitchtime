import Foundation

final class Storage {
    // Singleton instance
    static let shared = Storage()
    
    private init() {} // Prevent others from creating instances
    
    // Public method to log data
    func post(x: Double, y: Double, z: Double) {
        appendToCSV(x: x, y: y, z: z)
    }
    
    // Private helper method to append data to the CSV
    private func appendToCSV(x: Double, y: Double, z: Double) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let csvLine = "\(timestamp),\(x),\(y),\(z)\n"
        
        do {
            let docsURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileURL = docsURL.appendingPathComponent("accelerometer.csv")
            
            // If the file doesn’t exist, create it with headers
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                try "timestamp,x,y,z\n".write(to: fileURL, atomically: true, encoding: .utf8)
            }
            
            // Append new line
            let handle = try FileHandle(forWritingTo: fileURL)
            handle.seekToEndOfFile()
            if let data = csvLine.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
            
        } catch {
            print("Error writing to CSV: \(error)")
        }
    }
}
