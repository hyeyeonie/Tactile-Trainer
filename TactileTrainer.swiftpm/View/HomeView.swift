//
//  HomeView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/22/26.
//

import SwiftUI

struct HomeView: View {
    @State private var inputText: String = ""
    @StateObject private var hapticManager: TactileHapticManager
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    @FocusState private var isTextFieldFocused: Bool
    
    init() { _hapticManager = StateObject(wrappedValue: TactileHapticManager()) }
    
    var body: some View {
        ZStack {
            TactileTheme.highContrastBlack.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("촉지 연습")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(TactileTheme.textColor)
                    Text("연습하고 싶은 글자를 입력하고 촉지해 보세요")
                        .font(.system(size: 16))
                        .foregroundColor(isHighContrast ? .gray : .black.opacity(0.6))
                }
                .padding(.horizontal, 24).padding(.top, 30).frame(height: 120, alignment: .topLeading)
                
                searchBarSection
                
                if inputText.isEmpty { emptyGuideView }
                else { brailleLearningSection }
            }
        }
        .onTapGesture { isTextFieldFocused = false }
    }
    
    private var searchBarSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isHighContrast ? .gray : .black.opacity(0.4))
            
            // ## 힌트 텍스트 시인성 확보
            ZStack(alignment: .leading) {
                if inputText.isEmpty {
                    Text("글자를 입력하세요")
                        .font(.title3.bold())
                        .foregroundColor(isHighContrast ? .white.opacity(0.3) : .black.opacity(0.35))
                }
                TextField("", text: $inputText)
                    .font(.title3.bold())
                    .foregroundColor(TactileTheme.textColor)
                    .focused($isTextFieldFocused)
                    .autocorrectionDisabled()
            }
            
            if !inputText.isEmpty {
                Button(action: { inputText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(isHighContrast ? .gray : .black.opacity(0.3))
                }
            }
        }
        .padding(14)
        .background(isHighContrast ? Color.white.opacity(0.12) : Color.black.opacity(0.06))
        .cornerRadius(16).padding(.horizontal)
    }
    
    private var brailleLearningSection: some View {
        let units = TactileConverter.getBrailleUnits(for: inputText)
        return TabView {
            ForEach(units.indices, id: \.self) { idx in
                let unit = units[idx]
                VStack(spacing: 0) {
                    Spacer()
                    BraillePlate(
                        fullText: inputText, char: unit.char, dots: unit.dots.map { $0 ? 1 : 0 },
                        type: unit.type, activeDot: hapticManager.activeDot,
                        onTouch: { loc, w, h in
                            hapticManager.handleTouchInArea(unitIdx: idx, dots: unit.dots.map { $0 ? 1 : 0 }, loc: loc, viewWidth: w, viewHeight: h)
                        },
                        onTouchEnd: { hapticManager.reset() }
                    )
                    Spacer().frame(height: 60)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    private var emptyGuideView: some View {
        VStack {
            Spacer()
            Image(systemName: "hand.point.up.braille.fill").font(.system(size: 100)).foregroundColor(TactileTheme.mainColor)
            Text("연습할 글자를 입력해 보세요")
                .font(.title2.bold())
                .foregroundColor(TactileTheme.textColor.opacity(0.9)).padding(.top, 20)
            Spacer()
        }.frame(maxWidth: .infinity)
    }
}
