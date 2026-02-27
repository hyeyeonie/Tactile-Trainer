//
//  ScanView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/27/26.
//

import SwiftUI
import Vision
import AVFoundation

struct ScanView: View {
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    @StateObject private var cameraService = CameraService()
    
    @State private var scannedText: String = ""
    @State private var isShowingResult = false
    @State private var isLoading = false
    @State private var isCameraActive = false
    @State private var showToast = false
    
    private let viewfinderWidth: CGFloat = 320
    private let viewfinderHeight: CGFloat = 220
    
    var body: some View {
        NavigationStack {
            ZStack {
                (isHighContrast ? TactileTheme.highContrastBlack : Color(uiColor: .systemGroupedBackground))
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                        .padding(.top, 40)
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(isHighContrast ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
                                .frame(width: viewfinderWidth, height: viewfinderHeight)
                            
                            if isCameraActive {
                                CameraPreview(cameraService: cameraService)
                                    .frame(width: viewfinderWidth, height: viewfinderHeight)
                                    .cornerRadius(24)
                            } else {
                                Button(action: {
                                    isCameraActive = true
                                    cameraService.checkPermissions()
                                }) {
                                    VStack(spacing: 12) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 30))
                                        Text("카메라 켜기")
                                            .font(.headline)
                                    }
                                    .foregroundColor(TactileTheme.mainColor)
                                }
                            }
                            
                            RoundedRectangle(cornerRadius: 24)
                                .strokeBorder(TactileTheme.mainColor, style: StrokeStyle(lineWidth: 3, dash: [10, 8]))
                                .frame(width: viewfinderWidth, height: viewfinderHeight)
                        }
                        
                        Text(isCameraActive ? "한글 단어를 이 칸 안에 맞춰주세요" : "버튼을 눌러 스캔을 시작하세요")
                            .font(.callout.bold())
                            .foregroundColor(isHighContrast ? .white.opacity(0.8) : .black.opacity(0.6))
                            .padding(.top, 15)
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                    
                    if isCameraActive {
                        captureButtonSection
                    } else {
                        Color.clear.frame(height: 120)
                    }
                }
                
                if showToast {
                    VStack {
                        Spacer()
                        Text("한글을 인식하지 못했습니다. 다시 시도해주세요.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color.black.opacity(0.85))
                            .cornerRadius(25)
                            .padding(.bottom, 150)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                }
                
                if isLoading {
                    loadingOverlay
                }
            }
            .toolbar(.visible, for: .tabBar)
            .onAppear {
                isCameraActive = false
            }
            .toolbarColorScheme(isHighContrast ? .dark : .light, for: .navigationBar)
            .navigationDestination(isPresented: $isShowingResult) {
                ScanResultPracticeView(text: scannedText)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("주변 글자 스캔")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(isHighContrast ? .white : .black)
            
            Text("한글 단어를 스캔하여 점자로 학습합니다")
                .font(.system(size: 16))
                .foregroundColor(isHighContrast ? .white.opacity(0.6) : .black.opacity(0.5))
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var captureButtonSection: some View {
        Button(action: {
            isLoading = true
            cameraService.capturePhoto()
            cameraService.onPhotoTaken = { image in
                Task {
                    let result = await OCRManager.performOCR(on: image)
                    await MainActor.run {
                        isLoading = false
                        if !result.isEmpty {
                            self.scannedText = result
                            self.isCameraActive = false
                            self.isShowingResult = true
                        } else {
                            withAnimation {
                                self.showToast = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation { self.showToast = false }
                                self.isCameraActive = false
                            }
                        }
                    }
                }
            }
        }) {
            Circle()
                .fill(TactileTheme.mainColor)
                .frame(width: 80, height: 80)
                .overlay(Circle().stroke(Color.white, lineWidth: 4).padding(6))
                .shadow(radius: 10)
        }
        .padding(.bottom, 30)
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                Text("한글 분석 중...")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
    }
}
