//
//  stitchtimewatchappApp.swift
//  stitchtimewatchapp Watch App
//
//  Created by Nubra Jarial on 27/10/25.
//

import SwiftUI

@main
struct stitchtimewatchapp_Watch_AppApp: App {
    @StateObject private var motionManager = MotionManager()
    
    var body: some Scene {
        WindowGroup {
            WatchStartScreen()
        }
    };
}
