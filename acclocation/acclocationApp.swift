//
//  acclocationApp.swift
//  acclocation
//
//  Created by fnet on 2024/12/23.
//

import SwiftUI

@main
struct acclocationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                appDelegate.scheduleBackgroundTask()
            }
        }
    }
}
