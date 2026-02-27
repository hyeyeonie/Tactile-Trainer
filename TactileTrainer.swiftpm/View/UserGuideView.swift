//
//  UserGuideView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/27/26.
//

import SwiftUI

struct UserGuideView: View {
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    
    var body: some View {
        ZStack {
            TactileTheme.highContrastBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text("사용 가이드")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(TactileTheme.textColor)
                        .padding(.top, 10)

                    GuideSection(title: "1. 점자 위치 익히기", content: "기초 탭에서 점자 6점의 위치를 터치해보세요. 각 번호에 맞는 음성 안내와 진동이 제공됩니다.")
                    GuideSection(title: "2. 글자 연습하기", content: "연습 탭에서 단어를 입력하면 점자로 변환됩니다. 카드 하단의 점자판 영역을 부드럽게 쓸어가며 읽어보세요.")
                    GuideSection(title: "3. 스캔하여 읽기", content: "주변의 글자를 촬영하면 즉시 점자로 번역됩니다. 일상 속 글자들을 손끝으로 만나보세요.")
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(isHighContrast ? .yellow : Color(red: 1.0, green: 0.7, blue: 0.0))
                            Text("학습 팁")
                                .font(.headline)
                                .foregroundColor(isHighContrast ? .yellow : Color(red: 1.0, green: 0.7, blue: 0.0))
                        }
                        
                        Text("손가락을 떼지 않고 문지르듯 움직일 때 가장 정확한 점자 위치를 파악할 수 있습니다.")
                            .font(.subheadline)
                            .foregroundColor(TactileTheme.textColor.opacity(0.8))
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .background(isHighContrast ? Color.white.opacity(0.08) : Color.black.opacity(0.04))
                    .cornerRadius(16)
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(isHighContrast ? .dark : .light, for: .navigationBar)
    }
}

struct GuideSection: View {
    let title: String
    let content: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(TactileTheme.mainColor)
            Text(content)
                .font(.body)
                .foregroundColor(TactileTheme.textColor.opacity(0.8))
                .lineSpacing(6)
        }
    }
}
