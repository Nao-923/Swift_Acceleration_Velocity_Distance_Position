import Foundation
import CoreMotion

class SensorManager: ObservableObject {
    @Published var Data_AccelerateRaw:      String = "No Accelerometer Data"
    @Published var Data_AccelerateAverage:  String = "No Accelerometer Data"
    @Published var Data_Velocity:           String = "0.00 m/s"
    @Published var Data_VelocityAvarage:    String = "0.00 m/s"
    @Published var Data_Distance:           String = "0.00 m"
    @Published var Data_RelativePosition:   String = "0.00 m"

    private var motionManager: CMMotionManager
    
    //加速度
    private var cumulativeAccelerationX: [Double] = Array(repeating: 0.0, count: 100)
//    private var cumulativeAccelerationY: Array<Double> = Array(repeating: 0.0, count: 100)
//    private var cumulativeAccelerationZ: Array<Double> = Array(repeating: 0.0, count: 100)
    
    //速度
    private var velocityX: Double = 0.0
//    private var velocityY: Double = 0.0
//    private var velocityZ: Double = 0.0
    private var cumulativeVelocityX: Array<Double> = Array(repeating: 0.0, count: 100)
//    private var cumulativeVelocityY: Array<Double> = Array(repeating: 0.0, count: 100)
//    private var cumulativeVelocityZ: Array<Double> = Array(repeating: 0.0, count: 100)
    
    //距離
    private var distanceX: Double = 0.0
//    private var distanceY: Double = 0.0
//    private var distanceZ: Double = 0.0
    
    // 相対位置
    private var positionX: Double = 0.0
//    private var positionY: Double = 0.0
//    private var positionZ: Double = 0.0
    
    //その他
    private var dataCount: Int = 0
    private let threshold: Double = 0.4 // 加速度の閾値
    private var log: [String] = []
    

    init() {
        self.motionManager = CMMotionManager()
        print(cumulativeAccelerationX)
        print(cumulativeVelocityX)
        // 加速度センサーの初期設定
        motionManager.accelerometerUpdateInterval = 0.01 // 100Hz
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] data, error in
            guard let self = self, let data = data else { return }
            self.updateSensorData(acceleration: data.acceleration)
        }

        // 1秒ごとのクロックで計算を実行
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.processOneSecondData()
        }
    }

    private func applyThreshold(value: Double) -> Double {
        return abs(value) < threshold ? 0.0 : value
    }

    private func updateSensorData(acceleration: CMAcceleration) {
        // 閾値を適用した加速度
        let filteredAccelerationX = applyThreshold(value: acceleration.x)
//        let filteredAccelerationY = applyThreshold(value: acceleration.y)
//        let filteredAccelerationZ = applyThreshold(value: acceleration.z)

        // 累積加速度とデータ数を更新
        cumulativeAccelerationX.removeFirst()
        cumulativeAccelerationX.append(filteredAccelerationX)
//        print(cumulativeAccelerationX)
//        cumulativeVelocityY.removeFirst()
//        cumulativeAccelerationX.append(filteredAccelerationY)
//        cumulativeVelocityZ.removeFirst()
//        cumulativeAccelerationX.append(filteredAccelerationZ)
        
        // 加速度を元にした速度(V = V0 + a * t)
        velocityX = filteredAccelerationX
//        velocityY = filteredAccelerationY
//        velocityZ = filteredAccelerationZ
        
        cumulativeVelocityX.removeFirst()
        cumulativeVelocityX.append(velocityX)
        print(cumulativeAccelerationX)
//        cumulativeVelocityY.removeFirst()
//        cumulativeVelocityY.append(velocityY)
//        cumulativeVelocityZ.removeFirst()
//        cumulativeVelocityZ.append(velocityZ)
        
        dataCount += 1
        
        // UI更新
        DispatchQueue.main.async {
            self.Data_AccelerateRaw  = String(format: "X: %.2f m/s², Y: %.2f m/s², Z: %.2f m/s²",  filteredAccelerationX/*, filteredAccelerationY, filteredAccelerationZ*/)
            self.Data_Velocity       = String(format: "X: %.2f m/s, Y: %.2f m/s, Z: %.2f m/s",    self.velocityX/*,        self.velocityY,        self.velocityZ*/)
        }
        
    }

    private func processOneSecondData() {
        guard dataCount > 0 else { return }

        // 平均加速度を計算
        let meanAccelerationX = culculateAverage(cumulativeAccelerationX)
//        let meanAccelerationY = culculateAverage(cumulativeAccelerationY)
//        let meanAccelerationZ = culculateAverage(cumulativeAccelerationZ)
        
        // 平均速度
        let meanSpeedX = culculateAverage(cumulativeVelocityX)
//        let meanSpeedY = culculateAverage(cumulativeVelocityY)
//        let meanSpeedZ = culculateAverage(cumulativeVelocityZ)

        // 合計移動距離
        distanceX += fabs(meanSpeedX)
//        distanceY += fabs(meanSpeedY)
//        distanceZ += fabs(meanSpeedZ)

        // 相対移動距離
        positionX += meanSpeedX
//        positionY += meanSpeedY
//        positionZ += meanSpeedZ
        
        // データを記録
        let timestamp = getCurrentTimestamp()
        let logEntry = """
        timestamp:\(timestamp), meanAcc:x:\(meanAccelerationX)m/s², \
        meanSpeed:x:\(meanSpeedX)m/s, distance:\(self.distanceX)m
        """
        log.append(logEntry)

        // UI更新
        DispatchQueue.main.async {
            self.Data_AccelerateAverage = String(format: "X: %.2f m/s, Y: %.2f m/s, Z: %.2f m/s", meanAccelerationX/*,meanAccelerationY,meanAccelerationZ*/)
            self.Data_VelocityAvarage = String(format: "X: %.2f m/s, Y: %.2f m/s, Z: %.2f m/s", meanSpeedX/*, meanSpeedY, meanSpeedZ*/)
            self.Data_Distance = String(format:"X: %.2f m, Y: %.2f m, Z: %.2f m", self.distanceX/*, self.distanceY, self.distanceZ*/)
            self.Data_RelativePosition = String(format: "X: %.2f m, Y: %.2f m, Z: %.2f m", self.positionX/*, self.positionY, self.positionZ*/)
            
        }

        // 累積データをリセット
//        cumulativeAccelerationX = 0.0
//        dataCount = 0
    }
    
    func culculateAverage(_ values: [Double]) -> Double {
        values.reduce(0, +) / Double(values.count)
    }

    func saveLog() {
        let logText = log.joined(separator: "\n")
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("sensor_log.txt")
        do {
            try logText.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Log saved to: \(fileURL)")
        } catch {
            print("Error saving log: \(error.localizedDescription)")
        }
    }

    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
