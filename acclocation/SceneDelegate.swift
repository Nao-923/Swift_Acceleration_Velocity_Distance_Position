
import UIKit
import BackgroundTasks

func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.scheduleBackgroundTask()
}
