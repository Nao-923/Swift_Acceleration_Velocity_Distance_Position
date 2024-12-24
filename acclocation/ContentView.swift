import SwiftUI

struct ContentView: View {
    @StateObject private var sensorManager = SensorManager()

    var body: some View {
        VStack(spacing: 20) {
            // 加速度センサーの生データ
            Text("Acceleration Raw Data")
                .font(.headline)
                .foregroundColor(sensorManager.isRecording ? .green : (sensorManager.Data_AccelerateRaw == "No Accelerometer Data" ? .red : .black))
            Text(sensorManager.Data_AccelerateRaw)
                .padding()
                .border(Color.gray)
            
            // 平均加速度平均
            Text("Acceleration Average Data")
                .font(.headline)
                .foregroundColor(sensorManager.isRecording ? .green : (sensorManager.Data_AccelerateAverage == "No Accelerometer Data" ? .red : .black))
            Text(sensorManager.Data_AccelerateAverage)
                .padding()
                .border(Color.gray)
            
            // 速度
            Text("Velocity")
                .font(.headline)
                .foregroundColor(sensorManager.isRecording ? .green : (sensorManager.Data_Velocity == "No Accelerometer Data" ? .red : .black))
            Text(sensorManager.Data_Velocity)
                .padding()
                .border(Color.gray)
            
            // 平均速度
            Text("VelocityAverage")
                .font(.headline)
                .foregroundColor(sensorManager.isRecording ? .green : (sensorManager.Data_VelocityAvarage == "No Accelerometer Data" ? .red : .black))
            Text(sensorManager.Data_VelocityAvarage)
                .padding()
                .border(Color.gray)

            // 移動距離
            Text("TotalDistance")
                .font(.headline)
                .foregroundColor(sensorManager.isRecording ? .green : (sensorManager.Data_TotalDistance == "No Accelerometer Data" ? .red : .black))
            Text(sensorManager.Data_TotalDistance)
                .padding()
                .border(Color.gray)
            
            // 相対移動距離
            Text("RelativePosition")
                .font(.headline)
                .foregroundColor(sensorManager.isRecording ? .green : (sensorManager.Data_RelativePosition == "No Accelerometer Data" ? .red : .black))
            Text(sensorManager.Data_RelativePosition)
                .padding()
                .border(Color.gray)


            // データ保存ボタン
            Button(action: {
                sensorManager.toggleRecording()
                if !sensorManager.isRecording {
                    sensorManager.saveLog()
                }
            }) {
                Text(sensorManager.isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(sensorManager.isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

