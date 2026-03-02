//
//  BasicBrailleCell.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/26/26.
//

import SwiftUI

struct BasicBrailleCell: View {
    let activeDot: Int?
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    
    var body: some View {
        HStack(spacing: 30) {
            VStack(spacing: 30) {
                ForEach(1...3, id: \.self) { num in dotView(number: num) }
            }
            VStack(spacing: 30) {
                ForEach(4...6, id: \.self) { num in dotView(number: num) }
            }
        }
    }
    
    @ViewBuilder
    private func dotView(number: Int) -> some View {
        let isTouching = activeDot == number
        
        ZStack {
            Circle()
                .fill(
                    isTouching
                    ? TactileTheme.mainColor
                    : TactileTheme.inactiveDotColor
                )
                .frame(width: 100, height: 100)
                .shadow(color: isTouching ? TactileTheme.mainColor.opacity(0.5) : .clear, radius: 10)
            
            Text("\(number)")
                .font(.system(size: 36, weight: .black, design: .default))
                .foregroundColor(isTouching ? (isHighContrast ? .black : .white) : TactileTheme.textColor.opacity(0.4))
        }
        .animation(.spring(response: 0.2), value: isTouching)
    }
}
