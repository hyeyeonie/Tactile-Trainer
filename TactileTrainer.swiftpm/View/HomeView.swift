//
//  HomeView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/22/26.
//

import  SwiftUI

struct HomeView: View {
    @State private var inputText: String = ""
    @StateObject private var hapticManager: TactileHapticManager
    
    init() {
        _hapticManager = StateObject(wrappedValue: TactileHapticManager())
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                GroupBox {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("글자를 입력하세요 (예: 사과)", text: $inputText)
                            .font(.title3.bold())
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled()
                            .accessibilityLabel("입력창")
                        
                        if !inputText.isEmpty {
                            Button(action: { inputText = "" }) {
                                Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(8)
                }
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding()
                
                // 메인 보드 영역
                if inputText.isEmpty {
                    VStack(spacing: 30) {
                        Image(systemName: "hand.point.up.braille.fill")
                            .font(.system(size: 100))
                            .foregroundColor(TactileTheme.mainColor)
                        Text("연습할 글자를 입력해 보세요")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    let units = TactileConverter.getBrailleUnits(for: inputText)
                    
                    TabView {
                        ForEach(0..<units.count, id: \.self) { idx in
                            BraillePlate(char: units[idx].char,
                                         dots: units[idx].dots,
                                         type: units[idx].type,
                                         activeDot: hapticManager.activeDot)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(units[idx].char)의 \(units[idx].type) 카드")
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { val in
                                        hapticManager.handleTouch(unitIdx: idx, dots: units[idx].dots, loc: val.location)
                                    }
                                    .onEnded { _ in hapticManager.reset() }
                            )
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(maxHeight: .infinity)
                }
            }
            .navigationTitle("Tactile Trainer")
            .background(TactileTheme.highContrastBlack.ignoresSafeArea())
        }
    }
}
