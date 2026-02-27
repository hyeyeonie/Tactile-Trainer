//
//  DotCircle.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/22/26.
//

import SwiftUI

struct DotCircle: View {
    let isActive: Bool
    let isTouching: Bool
    var isHidden: Bool = false
    
    @AppStorage("isHighContrast") private var isHighContrast: Bool = true
    
    var body: some View {
        Circle()
            .fill(circleColor)
            .frame(width: 45, height: 45)
            .scaleEffect(isTouching ? 1.4 : 1.0)
            .animation(.spring(response: 0.3), value: isTouching)
    }
    
    private var circleColor: Color {
        if isHidden {
            if isTouching { return TactileTheme.activeHighlight }
            return isHighContrast ? Color.black.opacity(0.2) : Color.black.opacity(0.05)
        } else {
            if isActive {
                return isTouching ? TactileTheme.activeHighlight : TactileTheme.mainColor
            } else {
                return TactileTheme.inactiveDotColor
            }
        }
    }
}
