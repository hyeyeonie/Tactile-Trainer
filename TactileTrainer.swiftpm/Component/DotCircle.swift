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
    
    var body: some View {
        Circle()
            .fill(isActive ? (isTouching ? TactileTheme.activeHighlight : TactileTheme.mainColor) : Color.black.opacity(0.4))
            .frame(width: 45, height: 45)
            .scaleEffect(isTouching ? 1.4 : 1.0)
            .animation(.spring(response: 0.3), value: isTouching)
    }
}
