//
//  TactileConverter.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/22/26.
//

import SwiftUI

struct TactileConverter {
    
    static let hangeulCho: [Int: [Bool]] = [
        0: [false, false, false, true, false, false],
        1: [false, false, false, true, false, false],
        2: [false, true, false, true, false, false],
        3: [false, false, false, true, true, false],
        4: [false, false, false, true, true, false],
        5: [false, false, false, false, true, false],
        6: [false, true, false, true, true, false],
        7: [false, true, false, false, false, false],
        8: [false, true, false, false, false, false],
        9: [false, false, false, false, false, true],
        10: [false, false, false, false, false, true],
        11: [false, true, false, false, true, false],
        12: [false, false, false, true, false, true],
        13: [false, false, false, true, false, true],
        14: [false, false, false, false, true, true],
        15: [false, true, false, false, true, true],
        16: [false, true, false, true, false, true],
        17: [false, true, true, false, false, true],
        18: [false, true, true, false, true, false]
    ]
    
    static let hangeulJung: [Int: [Bool]] = [
        0: [true, true, false, false, false, true],
        1: [false, true, false, true, true, true],
        2: [true, false, true, false, false, true],
        3: [true, true, true, false, true, true],
        4: [true, false, true, true, true, false],
        5: [true, true, true, false, true, false],
        6: [true, false, false, true, true, true],
        7: [true, false, true, true, true, true],
        8: [true, false, true, false, true, true],
        9: [true, true, true, false, false, true],
        10: [true, true, true, false, true, true],
        11: [true, false, true, true, true, true],
        12: [true, false, true, false, true, false],
        13: [true, false, true, true, false, false],
        14: [true, true, false, true, false, true],
        15: [true, true, false, true, true, true],
        16: [true, true, true, true, false, false],
        17: [true, false, false, true, false, true],
        18: [false, true, false, true, false, true],
        19: [true, false, true, true, false, true],
        20: [true, false, true, false, true, false]
    ]
    
    static let hangeulJong: [Int: [Bool]] = [
        1: [true, false, false, false, false, false],
        2: [true, false, false, false, false, false],
        4: [false, true, false, false, false, true],
        7: [false, true, true, false, false, false],
        8: [false, true, false, false, false, false],
        16: [false, false, true, false, true, false],
        17: [true, true, false, false, false, false],
        19: [false, false, true, false, false, true],
        20: [false, false, true, false, false, true],
        21: [false, true, true, false, true, true],
        22: [true, false, true, false, false, false],
        23: [false, true, false, true, false, false],
        24: [false, true, false, false, true, false],
        25: [false, true, false, true, false, false],
        26: [false, true, false, false, false, true],
        27: [false, false, true, true, true, false]
    ]
    
    static func getBrailleUnits(for text: String) -> [(char: String, dots: [Bool], type: String)] {
        var units: [(char: String, dots: [Bool], type: String)] = []
        for char in text {
            let scalar = char.unicodeScalars.first?.value ?? 0
            if scalar >= 0xAC00 && scalar <= 0xD7A3 {
                let base = Int(scalar) - 0xAC00
                let cho = base / (21 * 28)
                let jung = (base % (21 * 28)) / 28
                let jong = base % 28
                
                if let cDots = hangeulCho[cho] { units.append((String(char), cDots, "초성")) }
                if let jDots = hangeulJung[jung] { units.append((String(char), jDots, "중성")) }
                if jong != 0, let fDots = hangeulJong[jong] { units.append((String(char), fDots, "종성")) }
            }
        }
        return units
    }
}
