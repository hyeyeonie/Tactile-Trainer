//
//  BasicView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/26/26.
//

import SwiftUI

struct BasicView: View {
    @StateObject private var hapticManager = TactileHapticManager()
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    private let allDots = [1, 1, 1, 1, 1, 1]
    
    var body: some View {
        ZStack {
            TactileTheme.highContrastBlack.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("점자 위치 익히기")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(TactileTheme.textColor)
                    
                    Text("점자 번호에 따라 촉지를 익혀보세요")
                        .font(.system(size: 16))
                        .foregroundColor(isHighContrast ? .gray : .black.opacity(0.6))
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .frame(height: 140, alignment: .topLeading)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(TactileTheme.cardGray)
                        .frame(width: 300, height: 450)
                        .shadow(color: isHighContrast ? .clear : .black.opacity(0.1), radius: 20)
                    
                    GeometryReader { geo in
                        BasicBrailleCell(activeDot: hapticManager.activeDot)
                            .frame(width: 230, height: 360)
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { val in
                                        hapticManager.handleTouch(unitIdx: 0, dots: allDots, loc: val.location, viewWidth: geo.size.width)
                                    }
                                    .onEnded { _ in hapticManager.reset() }
                            )
                    }
                    .frame(width: 300, height: 450)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                
                Spacer()

                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        if let active = hapticManager.activeDot {
                            Text("\(active)번 점")
                                .font(.system(size: 48, weight: .black, design: .default))
                                .foregroundColor(TactileTheme.mainColor)
                            Text("검지 손가락 위치를 확인하세요")
                                .font(.headline)
                                .foregroundColor(TactileTheme.mainColor.opacity(0.8))
                        } else {
                            Text("화면의 번호를 터치해보세요")
                                .font(.system(size: 17))
                                .foregroundColor(isHighContrast ? .gray : .black.opacity(0.6))
                        }
                    }
                    Spacer()
                }
                .frame(height: 120)
                .padding(.bottom, 20)
            }
        }
    }
}
