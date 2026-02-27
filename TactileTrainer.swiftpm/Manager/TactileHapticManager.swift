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
    
    @AppStorage("hapticIntensity") private var hapticIntensity: Double = 0.8
    
    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        engine = try? CHHapticEngine()
        try? engine?.start()
    }
    
    func handleTouch(unitIdx: Int, dots: [Int], loc: CGPoint, viewWidth: CGFloat) {
        let col = loc.x < (viewWidth / 2) ? 0 : 1
        let row: Int
        if loc.y < 130 { row = 0 }
        else if loc.y < 250 { row = 1 }
        else { row = 2 }
        
        processTouch(unitIdx: unitIdx, dots: dots, dotIdx: col * 3 + row)
    }

    func handleTouchInArea(unitIdx: Int, dots: [Int], loc: CGPoint, viewWidth: CGFloat, viewHeight: CGFloat) {
        let col = loc.x < (viewWidth / 2) ? 0 : 1
        let rowHeight = viewHeight / 3
        let row = Int(loc.y / rowHeight).clamped(to: 0...2)
        
        processTouch(unitIdx: unitIdx, dots: dots, dotIdx: col * 3 + row)
    }

    private func processTouch(unitIdx: Int, dots: [Int], dotIdx: Int) {
        if dotIdx >= 0 && dotIdx < 6 && dots[dotIdx] == 1 {
            let id = "\(unitIdx)-\(dotIdx)"
            if activeID != id {
                activeID = id
                activeDot = dotIdx + 1
                playImpact()
                announceDot(dotIdx + 1)
            }
        } else {
            activeID = ""
            activeDot = nil
        }
    }
    
    func playBraillePattern(dots: [Int]) {
        guard let engine = engine else { return }
        var events: [CHHapticEvent] = []
        for i in 0..<dots.count {
            if dots[i] == 1 {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(hapticIntensity))
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                let event = CHHapticEvent(eventType: .hapticTransient,
                                          parameters: [intensity, sharpness],
                                          relativeTime: Double(i) * 0.2)
                events.append(event)
            }
        }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch { print("패턴 재생 실패: \(error)") }
    }
    
    private func playImpact() {
        guard let engine = engine else { return }
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(hapticIntensity))
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

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
