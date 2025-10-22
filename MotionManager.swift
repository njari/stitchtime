import Foundation
import CoreMotion
import SQLite3

class MotionManager: ObservableObject {
    private let motion = CMMotionManager()
    
    @Published var accelX: Double = 0.0
    @Published var accelY: Double = 0.0
    @Published var accelZ: Double = 0.0
    
    var db: OpaquePointer?
    
    init() {
        openDatabase()
        createTable()
    }
    
    // Open or create the SQLite database in the app's Documents directory
    func openDatabase() {
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let fileURL = documentsURL.appendingPathComponent("accelerometer.sqlite")
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("error opening database")
            } else {
                print("Database opened at: \(fileURL.path)")
            }
        } catch {
            print("Error locating documents directory: \(error)")
        }
    }
    
    // Create table 'myveryfirstdata' with columns for x, y, and z values.
    func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS myveryfirstdata(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        x DOUBLE,
        y DOUBLE,
        z DOUBLE);
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("myveryfirstdata table created.")
            } else {
                print("myveryfirstdata table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    // Inserts accelerometer data into the 'myveryfirstdata' table.
    func insertAccelerometerData(x: Double, y: Double, z: Double) {
        let insertStatementString = "INSERT INTO myveryfirstdata (x, y, z) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_double(insertStatement, 1, x)
            sqlite3_bind_double(insertStatement, 2, y)
            sqlite3_bind_double(insertStatement, 3, z)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted data: (\(x), \(y), \(z))")
            } else {
                print("Could not insert data.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    // Start accelerometer updates and store the data in the SQLite database
    func startAccelerometerUpdates() {
        guard motion.isAccelerometerAvailable else {
            print("Accelerometer is not available.")
            return
        }
        
        motion.accelerometerUpdateInterval = 0.1
        motion.startAccelerometerUpdates(to: OperationQueue.current ?? OperationQueue.main) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }
            self.accelX = data.acceleration.x
            self.accelY = data.acceleration.y
            self.accelZ = data.acceleration.z
            
            // Insert the updated accelerometer values into the database.
            self.insertAccelerometerData(x: self.accelX, y: self.accelY, z: self.accelZ)
        }
    }
    
    // Stop accelerometer updates.
    func stopAccelerometerUpdates() {
        motion.stopAccelerometerUpdates()
    }
    
    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
}
