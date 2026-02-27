//
//  SettingView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/22/26.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("hapticIntensity") private var hapticIntensity: Double = 0.8
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                TactileTheme.highContrastBlack.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("설정")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(TactileTheme.textColor)
                        
                        Text("나에게 딱 맞는 촉각 피드백과 화면을 설정해 보세요")
                            .font(.system(size: 16))
                            .foregroundColor(isHighContrast ? .gray : .black.opacity(0.6))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 30)
                    .frame(height: 120, alignment: .topLeading)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "촉각 피드백")
                                
                                VStack(alignment: .leading, spacing: 18) {
                                    Label("진동 세기", systemImage: "waveform.path.ecg")
                                        .font(.headline)
                                        .foregroundColor(TactileTheme.textColor)
                                    
                                    Slider(value: $hapticIntensity, in: 0.1...1.0)
                                        .accentColor(TactileTheme.mainColor)
                                    
                                    HStack {
                                        Text("약하게")
                                        Spacer()
                                        Text("\(Int(hapticIntensity * 100))%")
                                            .fontWeight(.bold)
                                            .foregroundColor(TactileTheme.mainColor)
                                        Spacer()
                                        Text("강하게")
                                    }
                                    .font(.caption.bold())
                                    .foregroundColor(isHighContrast ? .secondary : .black.opacity(0.6))
                                }
                                .padding(22)
                                .background(TactileTheme.cardGray)
                                .cornerRadius(24)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "화면 설정")
                                
                                Toggle(isOn: $isHighContrast) {
                                    Label("고대비 모드 고정", systemImage: "circle.lefthalf.filled")
                                        .foregroundColor(TactileTheme.textColor)
                                }
                                .padding(22)
                                .background(TactileTheme.cardGray)
                                .cornerRadius(24)
                                
                                Text("고대비 모드는 요소를 더 명확히 구분할 수 있도록 흑백 대비를 강화합니다.")
                                    .font(.caption)
                                    .foregroundColor(isHighContrast ? .gray : .black.opacity(0.4))
                                    .padding(.horizontal, 4)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "지원")
                                
                                NavigationLink(destination: UserGuideView()) {
                                    HStack {
                                        Label("사용 가이드", systemImage: "book.pages")
                                            .foregroundColor(TactileTheme.textColor)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption.bold())
                                            .foregroundColor(.gray)
                                    }
                                    .padding(22)
                                    .background(TactileTheme.cardGray)
                                    .cornerRadius(24)
                                }
                            }
                        }
                        .padding(.top, 4)
                        .padding(.horizontal, 24)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(isHighContrast ? .dark : .light)
    }
}

struct SectionHeader: View {
    let title: String
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(isHighContrast ? .gray : .black.opacity(0.5))
            .padding(.horizontal, 4)
    }
}
