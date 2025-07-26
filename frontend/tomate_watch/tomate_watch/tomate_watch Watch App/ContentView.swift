//
//  ContentView.swift
//  tomate_watch Watch App
//
//  Created by 주승현 on 7/26/25.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @StateObject private var heartRateManager = HeartRateManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 현재 심박수 표시 (상시)
                CurrentHeartRateView(heartRateManager: heartRateManager)
                
                // 측정 버튼 영역
                MeasurementButtonView(heartRateManager: heartRateManager)
                
                // 구분선
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal)
                
                // 심박수 히스토리 리스트
                HeartRateHistoryView(heartRateManager: heartRateManager)
            }
            .padding(.vertical, 8)
        }
        .onAppear {
            heartRateManager.requestAuthorization()
        }
    }
}

// MARK: - CurrentHeartRateView (상시 표시)
struct CurrentHeartRateView: View {
    @ObservedObject var heartRateManager: HeartRateManager
    
    var body: some View {
        VStack(spacing: 8) {
            Text("현재 심박수")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let latestHeartRate = heartRateManager.heartRateData.first?.heartRate {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                    
                    Text("\(Int(latestHeartRate))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("BPM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("--")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
        )
        .padding(.horizontal)
    }
}

// MARK: - MeasurementButtonView
struct MeasurementButtonView: View {
    @ObservedObject var heartRateManager: HeartRateManager
    
    var body: some View {
        VStack(spacing: 12) {
            if !heartRateManager.isAuthorized {
                // 권한 요청
                Button("건강 데이터 권한 허용") {
                    heartRateManager.requestAuthorization()
                }
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                
            } else if heartRateManager.isMeasuring {
                // 측정 중
                VStack(spacing: 8) {
                    // 측정 중 애니메이션
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .scaleEffect(heartRateManager.heartbeatScale)
                            .animation(
                                .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                                value: heartRateManager.heartbeatScale
                            )
                        
                        Text("측정 중...")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    
                    // 타이머 표시
                    Text("\(heartRateManager.measurementTimeRemaining)초")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    // 현재 측정값 (있다면)
                    if let currentHeartRate = heartRateManager.currentHeartRate {
                        Text("\(Int(currentHeartRate)) BPM")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                    
                    // 측정 중지 버튼
                    Button("측정 완료") {
                        heartRateManager.stopMeasurement()
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.gray)
                    .cornerRadius(15)
                }
                
            } else {
                // 측정 시작 버튼
                Button("심박수 측정하기") {
                    heartRateManager.startMeasurement()
                }
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [.red, .red.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
            }
            
            // 측정 실패 메시지
            if heartRateManager.showMeasurementFailed {
                Text("심박수 인식이 어려워요\n손목에 잘 착용했는지 확인해주세요")
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - HeartRateHistoryView
struct HeartRateHistoryView: View {
    @ObservedObject var heartRateManager: HeartRateManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("심박수 기록")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(heartRateManager.heartRateData.count)개")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            if heartRateManager.heartRateData.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "heart.slash")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Text("아직 심박수 데이터가 없어요")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("측정 버튼을 눌러 심박수를 측정해보세요")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                
            } else {
                LazyVStack(spacing: 4) {
                    ForEach(Array(heartRateManager.heartRateData.enumerated()), id: \.element.id) { index, data in
                        HeartRateRowView(heartRateData: data, index: index)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - HeartRateRowView (개선된 디자인)
struct HeartRateRowView: View {
    let heartRateData: HeartRateData
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // 심박수 아이콘과 값
            HStack(spacing: 6) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.caption)
                
                Text("\(Int(heartRateData.heartRate))")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("BPM")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 날짜/시간 정보
            VStack(alignment: .trailing, spacing: 2) {
                Text(heartRateData.timeString)
                    .font(.caption2)
                    .foregroundColor(.primary)
                
                Text(heartRateData.relativeDateString)
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            
            // NEW 표시
            if heartRateData.isNewMeasurement {
                Text("NEW")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.orange)
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(index == 0 ? Color.gray.opacity(0.2) : Color.clear)
        )
    }
}

// MARK: - HeartRateData Model (개선)
struct HeartRateData {
    let id = UUID()
    let heartRate: Double
    let date: Date
    let isNewMeasurement: Bool
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var relativeDateString: String {
        let calendar = Calendar.current
        let now = Date()
        
        // 오늘인지 확인
        if calendar.isDate(date, inSameDayAs: now) {
            return "오늘"
        }
        
        // 어제인지 확인
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.isDate(date, inSameDayAs: yesterday) {
            return "어제"
        }
        
        // 그 외의 경우
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
}

// MARK: - HeartRateManager (개선)
class HeartRateManager: ObservableObject {
    private let healthStore = HKHealthStore()
    private var heartRateQuery: HKAnchoredObjectQuery?
    private var measurementTimer: Timer?
    
    @Published var heartRateData: [HeartRateData] = []
    @Published var currentHeartRate: Double?
    @Published var isAuthorized = false
    @Published var isMeasuring = false
    @Published var measurementTimeRemaining = 10
    @Published var showMeasurementFailed = false
    @Published var heartbeatScale: CGFloat = 1.0
    
    init() {
        checkAuthorizationStatus()
    }
    
    func checkAuthorizationStatus() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let status = healthStore.authorizationStatus(for: heartRateType)
        DispatchQueue.main.async {
            self.isAuthorized = (status == .sharingAuthorized)
            if self.isAuthorized {
                self.loadExistingHeartRateData()
            }
        }
    }
    
    func requestAuthorization() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.loadExistingHeartRateData()
                }
            }
        }
    }
    
    // 건강 앱에서 기존 심박수 데이터 로드
    func loadExistingHeartRateData() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now // 최근 7일
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: predicate,
            limit: 50, // 최근 50개
            sortDescriptors: [sortDescriptor]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let samples = samples as? [HKQuantitySample] {
                    let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                    
                    self.heartRateData = samples.map { sample in
                        let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                        return HeartRateData(
                            heartRate: heartRate,
                            date: sample.startDate,
                            isNewMeasurement: false
                        )
                    }
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    // 새로운 심박수 측정 시작 (10초 타이머 포함)
    func startMeasurement() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        isMeasuring = true
        currentHeartRate = nil
        measurementTimeRemaining = 10
        showMeasurementFailed = false
        heartbeatScale = 1.2 // 애니메이션 시작
        
        // 10초 타이머 시작
        measurementTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            DispatchQueue.main.async {
                self?.measurementTimeRemaining -= 1
                
                if self?.measurementTimeRemaining == 0 {
                    self?.handleMeasurementTimeout()
                }
            }
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: .strictEndDate)
        
        heartRateQuery = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: predicate,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] _, samples, deletedObjects, anchor, error in
            self?.handleNewHeartRateSamples(samples)
        }
        
        heartRateQuery?.updateHandler = { [weak self] _, samples, deletedObjects, anchor, error in
            self?.handleNewHeartRateSamples(samples)
        }
        
        healthStore.execute(heartRateQuery!)
    }
    
    // 측정 완료
    func stopMeasurement() {
        measurementTimer?.invalidate()
        measurementTimer = nil
        
        if let query = heartRateQuery {
            healthStore.stop(query)
            heartRateQuery = nil
        }
        
        isMeasuring = false
        heartbeatScale = 1.0 // 애니메이션 중지
        showMeasurementFailed = false
        
        // 측정된 심박수를 리스트에 추가
        if let heartRate = currentHeartRate {
            let newData = HeartRateData(
                heartRate: heartRate,
                date: Date(),
                isNewMeasurement: true
            )
            
            heartRateData.insert(newData, at: 0) // 맨 위에 추가
            
            // TODO: API 호출 부분 (주석 처리)
            // sendHeartRateToAPI(heartRate: heartRate, date: Date())
            
            currentHeartRate = nil
        }
    }
    
    // 측정 타임아웃 처리
    private func handleMeasurementTimeout() {
        measurementTimer?.invalidate()
        measurementTimer = nil
        
        if let query = heartRateQuery {
            healthStore.stop(query)
            heartRateQuery = nil
        }
        
        isMeasuring = false
        heartbeatScale = 1.0
        
        if currentHeartRate == nil {
            // 10초 동안 인식 안됨
            showMeasurementFailed = true
            
            // 3초 후에 메시지 숨기기
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showMeasurementFailed = false
            }
        } else {
            // 인식된 경우 자동으로 완료
            stopMeasurement()
        }
    }
    
    private func handleNewHeartRateSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
        
        if let latestSample = samples.last {
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            let heartRate = latestSample.quantity.doubleValue(for: heartRateUnit)
            
            DispatchQueue.main.async {
                self.currentHeartRate = heartRate
            }
        }
    }
    
    // MARK: - API 호출 (주석 처리)
    /*
    private func sendHeartRateToAPI(heartRate: Double, date: Date) {
        // API 엔드포인트 예시
        let apiURL = "https://your-api-server.com/api/heartrate"
        
        let parameters = [
            "heartRate": heartRate,
            "timestamp": date.timeIntervalSince1970,
            "userId": "user_id_here"
        ]
        
        // URLSession을 사용한 API 호출
        // guard let url = URL(string: apiURL) else { return }
        // var request = URLRequest(url: url)
        // request.httpMethod = "POST"
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // 
        // do {
        //     request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        //     URLSession.shared.dataTask(with: request) { data, response, error in
        //         // API 응답 처리
        //     }.resume()
        // } catch {
        //     print("API 호출 실패: \(error)")
        // }
        
        print("API 호출 예정 - 심박수: \(heartRate), 날짜: \(date)")
    }
    */
}

#Preview {
    ContentView()
}
