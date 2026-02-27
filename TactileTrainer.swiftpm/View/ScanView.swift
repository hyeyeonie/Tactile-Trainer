//
//  ScanView.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/27/26.
//

import SwiftUI

struct ScanView: View {
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    @State private var scannedText: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                TactileTheme.highContrastBlack.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("주변 글자 스캔")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(TactileTheme.textColor)
                        
                        Text("카메라로 주변의 글자를 촬영하여 점자로 확인하세요")
                            .font(.system(size: 16))
                            .foregroundColor(isHighContrast ? .gray : .black.opacity(0.6))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 30)
                    .frame(height: 120, alignment: .topLeading)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(isHighContrast ? Color.white.opacity(0.1) : Color.black.opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(TactileTheme.mainColor, style: StrokeStyle(lineWidth: 3, dash: [10, 5]))
                                    .padding(40)
                            )
                        
                        if scannedText.isEmpty {
                            VStack {
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 50))
                                    .foregroundColor(TactileTheme.mainColor)
                                Text("인식할 글자를 사각형 안에 맞춰주세요")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                    Button(action: {
                        print("Scan Started")
                    }) {
                        Circle()
                            .fill(TactileTheme.mainColor)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .padding(6)
                            )
                            .shadow(radius: 10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 30)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(isHighContrast ? .dark : .light)
    }
}
