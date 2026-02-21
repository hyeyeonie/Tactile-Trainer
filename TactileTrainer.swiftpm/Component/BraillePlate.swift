//
//  BraillePlate.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/22/26.
//

import SwiftUI

struct BraillePlate: View {
    let char: String
    let dots: [Bool]
    let type: String
    let activeDot: Int?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(type)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(TactileTheme.mainColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            
            Text(char)
                .font(.system(size: 60, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            
            VStack(spacing: 30) {
                ForEach(0..<3) { row in
                    HStack(spacing: 40) {
                        DotCircle(isActive: dots[row], isTouching: activeDot == row)
                        DotCircle(isActive: dots[row+3], isTouching: activeDot == row+3)
                    }
                }
            }
        }
        .frame(width: 260, height: 450)
        .background(TactileTheme.cardGray)
        .cornerRadius(40)
        .shadow(color: .white.opacity(0.1), radius: 10)
    }
}
