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
            // 이미지 시퀀스 애니메이션 영역 (전체 화면)
            ImageSequenceAnimationView()
            
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

// MARK: - 이미지 시퀀스 애니메이션 뷰
struct ImageSequenceAnimationView: View {
    @State private var currentFrame = 0
    @State private var animationTimer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = loadAnimationFrame(currentFrame) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 1.58
                    )
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 1.58
                    )
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            
                            Text("애니메이션")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
            }
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    // 애니메이션 프레임 로드
    private func loadAnimationFrame(_ frameIndex: Int) -> UIImage? {
        let imageName = "anim\(frameIndex)"
        return UIImage(named: imageName)
    }
    
    // 애니메이션 시작
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            currentFrame = (currentFrame + 1) % 20 // 0~19 프레임 순환
        }
    }
    
    // 애니메이션 중지
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
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
