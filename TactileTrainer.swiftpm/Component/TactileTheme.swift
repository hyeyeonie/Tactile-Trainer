//
//  TactileTheme.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/27/26.
//

import SwiftUI

@MainActor
struct TactileTheme {
    static var isHighContrast: Bool {
        UserDefaults.standard.bool(forKey: "isHighContrast")
    }

    static var mainColor: Color {
        isHighContrast ? Color(red: 0.1, green: 0.6, blue: 1.0) : Color.blue
    }

    static var highContrastBlack: Color {
        isHighContrast ? Color.black : Color(white: 0.96)
    }

    static var cardGray: Color {
        isHighContrast ? Color(white: 0.18) : Color.white
    }

    static var activeHighlight: Color {
        isHighContrast ? Color.yellow : Color.yellow.opacity(0.9)
    }
    
    static var inactiveDotColor: Color {
        isHighContrast ? Color.white.opacity(0.15) : Color.black.opacity(0.1)
    }

    static var textColor: Color {
        isHighContrast ? .white : .black
    }
}
