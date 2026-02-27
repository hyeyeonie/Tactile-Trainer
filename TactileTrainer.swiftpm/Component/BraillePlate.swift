//
//  BraillePlate.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/22/26.
//

import SwiftUI

struct BraillePlate: View {
    let fullText: String
    let char: String
    let dots: [Int]
    let type: String
    let activeDot: Int?
    var isHidden: Bool = false
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    
    var onTouch: ((CGPoint, CGFloat, CGFloat) -> Void)?
    var onTouchEnd: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text(type)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal, 18).padding(.vertical, 8)
                    .background(TactileTheme.mainColor).foregroundColor(.white).clipShape(Capsule())
                
                HStack(spacing: 6) {
                    ForEach(Array(fullText.enumerated()), id: \.offset) { _, c in
                        Text(String(c))
                            .font(.system(size: 60, weight: .black))
                            .foregroundColor(String(c) == char ? TactileTheme.mainColor : TactileTheme.inactiveDotColor)
                    }
                }
            }
            .padding(.top, 30).opacity(isHidden ? 0 : 1)
            
            Spacer()
            
            GeometryReader { geo in
                VStack(spacing: 30) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 40) {
                            DotCircle(isActive: dots[row] == 1, isTouching: activeDot == (row + 1))
                            DotCircle(isActive: dots[row+3] == 1, isTouching: activeDot == (row + 4))
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { val in
                            onTouch?(val.location, geo.size.width, geo.size.height)
                        }
                        .onEnded { _ in onTouchEnd?() }
                )
            }
            .frame(height: 220).padding(.bottom, 40)
        }
        .frame(width: 300, height: 450)
        .background(TactileTheme.cardGray)
        .cornerRadius(32)
        .shadow(color: isHighContrast ? .clear : .black.opacity(0.1), radius: 15)
    }
}
