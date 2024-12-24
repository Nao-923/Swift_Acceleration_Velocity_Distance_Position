import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.SensorManagerTask", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
        return true
    }

    func scheduleBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "com.example.SensorManagerTask")
        request.requiresExternalPower = false
        request.requiresNetworkConnectivity = false

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to schedule background task: \(error)")
        }
    }

    func handleBackgroundTask(task: BGProcessingTask) {
        let sensorManager = SensorManager()
        sensorManager.startAccelerometerUpdates()

        task.expirationHandler = {
            sensorManager.stopAccelerometerUpdates()
        }

        task.setTaskCompleted(success: true)
    }
}
