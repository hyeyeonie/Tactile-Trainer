//
//  UserGuideView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/27/26.
//

import SwiftUI

import SwiftUI

struct UserGuideView: View {
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    
    var body: some View {
        ZStack {
            (isHighContrast ? TactileTheme.highContrastBlack : Color(uiColor: .systemGroupedBackground))
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    Text("사용 가이드")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(isHighContrast ? .white : .black)
                        .padding(.top, 10)

                    GuideSection(
                        title: "1. 점자 기초 체계 익히기",
                        content: "기초 탭의 2x3 점자판에서 6개 점의 고유 위치를 터치해 보세요. 각 번호에 대응하는 진동 피드백과 음성 안내를 통해 점자의 기본 구조를 익힐 수 있습니다."
                    )

                    GuideSection(
                        title: "2. 텍스트 입력 및 연습",
                        content: "연습 탭에서 단어를 입력하면 즉시 표준 점자로 변환됩니다. 생성된 점자 카드를 좌우로 넘기며 글자별 모양을 익히고, 화면 중앙의 점자판 영역을 손가락으로 문질러 촉지해 보세요."
                    )

                    GuideSection(
                        title: "3. 카메라 스캔 및 실전 촉지",
                        content: "주변의 한글 단어를 촬영하면 즉시 점자로 변환됩니다. 본 기능은 '한글 단어' 전용으로 설계되었으며, 한 번에 최대 5글자까지 인식하여 정교한 학습 환경을 제공합니다. (영어, 숫자 및 특수문자는 인식되지 않습니다.)"
                    )
                    
                    learningTipView
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var learningTipView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("학습 팁")
                    .font(.headline)
                    .foregroundColor(.yellow)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("• 점자판 위에서 손가락을 떼지 않고 부드럽게 문지르듯 움직일 때 점의 위치를 가장 정확하게 파악할 수 있습니다.")
                Text("• 스캔 시에는 배경과 글자의 대비가 뚜렷하고, 한글 단어가 가이드 사각형 안에 잘 들어오도록 촬영해 주세요.")
            }
            .font(.subheadline)
            .foregroundColor(isHighContrast ? .white.opacity(0.8) : .black.opacity(0.7))
            .lineSpacing(4)
        }
        .padding(20)
        .background(isHighContrast ? Color.white.opacity(0.08) : Color.black.opacity(0.04))
        .cornerRadius(16)
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
