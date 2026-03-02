//
//  OCRManager.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/27/26.
//

import AVFoundation
import UIKit
import Vision

struct OCRManager {
    static func performOCR(on image: UIImage) async -> String {
        guard let cgImage = image.cgImage else { return "" }
        
        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: "")
                    return
                }
                
                let recognizedStrings = observations
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "")
                
                let hangulOnly = recognizedStrings.filter { char in
                    guard let scalar = char.unicodeScalars.first else { return false }
                    return (0xAC00...0xD7A3).contains(scalar.value)
                }
                
                let limitedText = String(hangulOnly.prefix(5))
                
                continuation.resume(returning: limitedText)
            }
            
            request.recognitionLanguages = ["ko-KR"]
            request.recognitionLevel = .accurate
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(returning: "")
            }
        }
    }
}
