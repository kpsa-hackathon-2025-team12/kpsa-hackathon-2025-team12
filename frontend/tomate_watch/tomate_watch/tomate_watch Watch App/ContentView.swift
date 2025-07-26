//
//  ContentView.swift
//  tomate_watch Watch App
//
//  Created by 주승현 on 7/26/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var heartRateManager = SimpleHeartRateManager()
    
    var body: some View {
        VStack(spacing: 0) {
            // GIF 이미지 표시 영역 (전체 화면)
            GifImageView()
            
            Spacer()
                .frame(height: 16)
            
            // 간단한 심박수 표시 (하단)
            SimpleHeartRateView(heartRateManager: heartRateManager)
            
            Spacer()
                .frame(height: 20)
        }
        .ignoresSafeArea()
        .onAppear {
            heartRateManager.startSimulation()
        }
        .onDisappear {
            heartRateManager.stopSimulation()
        }
    }
}

// MARK: - GIF 이미지 뷰 (전체 화면)
struct GifImageView: View {
    var body: some View {
        GeometryReader { geometry in
            if let gifImage = loadGifImage() {
                Image(uiImage: gifImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 1.58
                    )
                    .clipped()
            } else {
                // GIF 파일이 없을 때 플레이스홀더
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.7
                    )
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            
                            Text("GIF")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
            }
        }
    }
    
    // Bundle에서 GIF 파일 로드
    private func loadGifImage() -> UIImage? {
        print("GIF 로드 시도 중...")
        
        // 여러 가능한 파일 이름으로 시도
        let possibleNames = ["watch.gif", "watch", "토마토.gif", "tomato.gif"]
        
        for fileName in possibleNames {
            print("시도 중: \(fileName)")
            
            if let path = Bundle.main.path(forResource: fileName, ofType: nil) {
                print("파일 경로 찾음: \(path)")
                if let data = NSData(contentsOfFile: path) {
                    print("데이터 로드 성공: \(data.length) bytes")
                    return UIImage(data: data as Data)
                } else {
                    print("데이터 로드 실패")
                }
            }
            
            // 확장자 없이 시도
            let nameWithoutExtension = fileName.replacingOccurrences(of: ".gif", with: "")
            if let path = Bundle.main.path(forResource: nameWithoutExtension, ofType: "gif") {
                print("확장자 분리 경로 찾음: \(path)")
                if let data = NSData(contentsOfFile: path) {
                    print("확장자 분리 데이터 로드 성공: \(data.length) bytes")
                    return UIImage(data: data as Data)
                }
            }
        }
        
        print("모든 시도 실패")
        return nil
    }
}

// MARK: - 간단한 심박수 뷰 (컨테이너 없이)
struct SimpleHeartRateView: View {
    @ObservedObject var heartRateManager: SimpleHeartRateManager
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.title2)
                .scaleEffect(heartRateManager.heartbeatScale)
                .animation(
                    .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                    value: heartRateManager.heartbeatScale
                )
            
            Text("\(heartRateManager.currentHeartRate)")
                .font(.system(size: 37, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .animation(.easeInOut(duration: 0.3), value: heartRateManager.currentHeartRate)
            
            Text("BPM")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.red)
                .offset(y: 4)
        }
        .offset(y: 10)
    }
}

// MARK: - 간단한 심박수 시뮬레이션 매니저
class SimpleHeartRateManager: ObservableObject {
    @Published var currentHeartRate: Int = 110
    @Published var heartbeatScale: CGFloat = 1.0
    
    private var timer: Timer?
    
    init() {
        startHeartbeatAnimation()
    }
    
    func startSimulation() {
        // 2초마다 100-120 사이의 랜덤값 생성
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            DispatchQueue.main.async {
                self.currentHeartRate = Int.random(in: 90...120)
            }
        }
    }
    
    func stopSimulation() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startHeartbeatAnimation() {
        // 심장 박동 애니메이션
        heartbeatScale = 1.4
    }
    
    deinit {
        stopSimulation()
    }
}

#Preview {
    ContentView()
}
