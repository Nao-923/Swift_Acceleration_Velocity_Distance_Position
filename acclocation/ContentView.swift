import SwiftUI

struct ContentView: View {
    @StateObject private var sensorManager = SensorManager()

    var body: some View {
        VStack(spacing: 20) {
            // 加速度センサーの生データ
            Text("Acceleration Raw Data")
                .font(.headline)
            Text(sensorManager.Data_AccelerateRaw)
                .padding()
                .border(Color.gray)
            
            // 平均加速度平均
            Text("Acceleration Average Data")
                .font(.headline)
            Text(sensorManager.Data_AccelerateAverage)
                .padding()
                .border(Color.gray)
            
            // 速度
            Text("Velocity")
                .font(.headline)
            Text(sensorManager.Data_Velocity)
                .padding()
                .border(Color.gray)
            
            // 平均速度
            Text("VelocityAverage")
                .font(.headline)
            Text(sensorManager.Data_VelocityAvarage)
                .padding()
                .border(Color.gray)

            // 移動距離
            Text("TotalDistance")
                .font(.headline)
            Text(sensorManager.Data_Distance)
                .padding()
                .border(Color.gray)
            
            // 相対移動距離
            Text("RelativePosition")
                .font(.headline)
            Text(sensorManager.Data_RelativePosition)
                .padding()
                .border(Color.gray)


            // データ保存ボタン
            Button(action: {
                sensorManager.saveLog()
            }) {
                Text("Save Log")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

