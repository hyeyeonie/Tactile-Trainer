//
//  TactileHapticManager.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/22/26.
//

import SwiftUI
import CoreHaptics

@MainActor
class TactileHapticManager: ObservableObject {
    private var engine: CHHapticEngine?
    @Published var activeDot: Int? = nil
    private var activeID: String = ""
    
    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        engine = try? CHHapticEngine()
        try? engine?.start()
    }
    
    func handleTouch(unitIdx: Int, dots: [Bool], loc: CGPoint) {
        let col = loc.x < 110 ? 0 : 1
        let row = Int(loc.y / 126)
        let dotIdx = col * 3 + row
        
        if dotIdx >= 0 && dotIdx < 6 && dots[dotIdx] {
            let id = "\(unitIdx)-\(dotIdx)"
            if activeID != id {
                activeID = id
                activeDot = dotIdx
                playImpact()
                announceDot(dotIdx + 1)
            }
        } else {
            activeID = ""
            activeDot = nil
        }
    }
    
    private func playImpact() {
        guard let engine = engine else { return }
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        
        try? engine.makePlayer(with: CHHapticPattern(events: [event], parameters: [])).start(atTime: 0)
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    private func announceDot(_ number: Int) {
        if UIAccessibility.isVoiceOverRunning {
            UIAccessibility.post(notification: .announcement, argument: "\(number)번 점")
        }
    }
    
    func reset() {
        activeDot = nil
        activeID = ""
    }
}
